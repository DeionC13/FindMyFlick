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
    
    @IBOutlet weak var scrollPageStackView: UIStackView!
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieDescription: UILabel!
    var currentMovie: Results?

    @IBOutlet weak var netflixCheck: UIImageView!
    
    @IBOutlet weak var amazonCheck: UIImageView!
    
    @IBOutlet weak var disneyCheck: UIImageView!
    
    @IBOutlet weak var huluCheck: UIImageView!
    
    @IBOutlet weak var hboCheck: UIImageView!
    
    @IBOutlet weak var peacockCheck: UIImageView!
    
    
    @IBOutlet weak var scrollPage: UIScrollView!
    
    

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
            self.movieTitle.text = movie.title
            streamingManager.performStreamingServicesRequest(for: movie.title)
        }
        scrollPage.isDirectionalLockEnabled = true
        scrollPage.alwaysBounceVertical = true
        scrollPage.contentSize = CGSizeMake(1000, 500)
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
}
//MARK: - Streaming Manager Functions
extension DetailsViewController: StreamingManagerDelegate {
    func didSelectMovie(_ streamingManager: StreamingManager, streamInfo: StreamingModel) {
            self.movieDescription.text = streamInfo.overview
            self.updateStreamingLabels(platforms: streamInfo.platform)
    }
  
    func didFailWithError(error: Error) {
        
    }
    
    func updateStreamingLabels(platforms: [String]?){
       if let safePlatforms = platforms{
           if safePlatforms.contains("netflix"){
                self.netflixCheck.image = UIImage(systemName: "checkmark.seal.fill")
            }
             if safePlatforms.contains("hbo"){
                 self.hboCheck.image = UIImage(systemName: "checkmark.seal.fill")
             }
            if safePlatforms.contains("disney"){
                self.disneyCheck.image = UIImage(systemName: "checkmark.seal.fill")
            }
            if safePlatforms.contains("peacock"){
                self.peacockCheck.image = UIImage(systemName: "checkmark.seal.fill")
            }
            if safePlatforms.contains("hulu"){
                self.huluCheck.image = UIImage(systemName: "checkmark.seal.fill")
            }
            if safePlatforms.contains("prime"){
                self.amazonCheck.image = UIImage(systemName: "checkmark.seal.fill")
            }
       }
    }
    
    
}
