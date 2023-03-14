//
//  DetailsViewController.swift
//  FindMyFlick
//
//  Created by Deion caldwell on 1/31/23.
//

import UIKit

class DetailsViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    
    @IBOutlet weak var movieImageStackView: UIStackView!
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieDescription: UILabel!
    var currentMovie: Results?
    
    @IBOutlet weak var scrollPage: UIScrollView!

    
    @IBOutlet var labelCollection: [UIButton]!
    var labelSites = [String]()
    
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var streamingManager = StreamingManager()
    
    
    //MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        updateImage(imageURL: currentMovie?.image)
        streamingManager.delegate = self
        scrollPage.delegate = self
        self.view.backgroundColor = UIColor(red: 0.88, green: 0.75, blue: 0.59, alpha: 1.00)
        
        if let movie = currentMovie {
            //            self.movieTitle.text = movie.title
            streamingManager.performStreamingServicesRequest(for: movie.title)
        }
        scrollPage.isDirectionalLockEnabled = true
        scrollPage.alwaysBounceVertical = true
        scrollPage.contentSize = CGSizeMake(1000, 600)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.scrollPage.contentSize.width = self.scrollPage.frame.size.width
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            mainStackView.axis = .horizontal
        } else {
            mainStackView.axis = .vertical
        }
    }
    
    
    func updateImage(imageURL: String?) {
        
        if let url = URL(string: imageURL!){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    return
                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        self.movieImage.image = UIImage(data: safeData)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    @IBAction func streamLabelTapped(_ sender: UIButton) {
       
        
    }
    
    
    
    
}
//MARK: - Streaming Manager Functions
extension DetailsViewController: StreamingManagerDelegate {
    func didSelectMovie(_ streamingManager: StreamingManager, streamInfo: StreamingModel) {
        self.movieDescription.text = streamInfo.overview
        
        self.getStreamingLabels(platforms: streamInfo.platform)
        
    }
    
    func didFailWithError(error: Error) {
        
    }
    
    
    func getStreamingLabels(platforms: [String]?) {
        
        var images = [UIImage]()
        var websites = [String]()
        var collectionCounter = 0
        if let safePlatforms = platforms {
            for platform in safePlatforms {
                if let platformImage = UIImage(named: "\(platform)Logo"){
                    websites.append("https://www.\(platform).com")
                    images.append(platformImage)
                }
            }
            
            while collectionCounter < images.count {
                labelCollection[collectionCounter].setImage(images[collectionCounter].withRenderingMode(.alwaysOriginal), for: .normal)
                collectionCounter += 1
            }
        }
        
    }
    
}
