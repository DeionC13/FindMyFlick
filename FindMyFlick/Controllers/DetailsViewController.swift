//
//  DetailsViewController.swift
//  FindMyFlick
//
//  Created by Deion caldwell on 1/31/23.
//

import UIKit

class DetailsViewController: UIViewController, UIScrollViewDelegate {
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
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollPage.delegate = self
        self.view.backgroundColor = UIColor(red: 0.88, green: 0.75, blue: 0.59, alpha: 1.00)
       
        updateImage(imageURL: currentMovie?.image)
        
        movieTitle.text = currentMovie?.title
        movieDescription.text = currentMovie?.description
        performStreamingServicesRequest()
        scrollPage.contentSize = CGSizeMake(1000, 500)
        
    
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
    
    func performStreamingServicesRequest() {
        var movieName = movieTitle.text!
        var finalMovieName = movieName.replacingOccurrences(of: " ", with: "%20")
        let headers = [
            "X-RapidAPI-Key": "fecbb3b30emsh2ebb19545f0c50dp176ae9jsnc6097f2b9802",
            "X-RapidAPI-Host": "streaming-availability.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://streaming-availability.p.rapidapi.com/v2/search/title?title=\(finalMovieName)&country=us&type=movie&output_language=en")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print("error fetching rapidAPI \(error)")
                return
            }
            if let data = data,
               let streamInfo = self.parseJSON(data) {
                DispatchQueue.main.async{
                    print(streamInfo.platform!)
                    self.movieDescription.text = streamInfo.overview
                    self.updateStreamingLabels(platforms: streamInfo.platform!)
                }
            }
        })

        dataTask.resume()
        
    }
    func updateStreamingLabels(platforms: [String]){
        
        
       if platforms.contains("netflix"){
            self.netflixCheck.image = UIImage(systemName: "checkmark.seal.fill")
        }
         if platforms.contains("hbo"){
             self.hboCheck.image = UIImage(systemName: "checkmark.seal.fill")
         }
        if platforms.contains("disney"){
            self.disneyCheck.image = UIImage(systemName: "checkmark.seal.fill")
        }
        if platforms.contains("peacock"){
            self.peacockCheck.image = UIImage(systemName: "checkmark.seal.fill")
        }
        if platforms.contains("hulu"){
            self.huluCheck.image = UIImage(systemName: "checkmark.seal.fill")
        }
        if platforms.contains("prime"){
            self.amazonCheck.image = UIImage(systemName: "checkmark.seal.fill")
        }
            
        
        
        
    }
    
    func parseJSON(_ data: Data) -> StreamingModel?{
        let decoder = JSONDecoder()
        var streamingPlatform: [String] = []
        var watchLink: String?
        do {
            let decodedData = try decoder.decode(StreamingData.self, from: data)
            let trailer = decodedData.result[0].youtubeTrailerVideoLink
            let overview = decodedData.result[0].overview
            let tagline = decodedData.result[0].tagline
            let results = decodedData.result
//            let watchLink = decodedData.result[0].streamingInfo.us?.netflix?[0].link
            if let country = decodedData.result[0].streamingInfo.us {
                if country.netflix != nil {
                    streamingPlatform.append("netflix")
                }
                if country.hbo != nil {
                    streamingPlatform.append("hbo")
                }
                if country.hulu != nil {
                    streamingPlatform.append("hulu")
                }
                if country.apple != nil {
                    streamingPlatform.append("apple")
                }
                if country.prime != nil {
                    streamingPlatform.append("prime")
                }
                if country.disney != nil {
                    streamingPlatform.append("disney")
                }
                if country.peacock != nil {
                    streamingPlatform.append("peacock")
                }
                
            }
         let streamingPlatformInfo = StreamingModel(youtubeTrailer: trailer, overview: overview, tagline: tagline, platform: streamingPlatform)
            return streamingPlatformInfo
        } catch {
            print(error)
            return nil
        }
    }
}
