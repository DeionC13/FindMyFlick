//
//  StreamingManager.swift
//  FindMyFlick
//
//  Created by Deion caldwell on 2/18/23.
//
import UIKit

protocol StreamingManagerDelegate {
    
    func didSelectMovie(_ streamingManager: StreamingManager, streamInfo: StreamingModel)
    func didFailWithError(error: Error)
}

struct StreamingManager {
    var delegate: StreamingManagerDelegate?
    var streamingLabels: [UIImage]?
    
    func parseJSON(data: Data, for name: String) -> StreamingModel?{
        let decoder = JSONDecoder()
        var streamingPlatform: [String] = []
        var watchLink: String?
        var model: StreamingModel?
        
        do {
            let decodedData = try decoder.decode(StreamingData.self, from: data)
            
        outerLoop: for item in decodedData.result {
            
                if item.title == name {
                    let title = item.title
                    let trailer = item.youtubeTrailerVideoLink
                    let overview = item.overview
                    let tagline = item.tagline
                    let results = item
                    let image = item.backdropURLs.original
                    if let country = item.streamingInfo.us {
                                    
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
                        let streamingPlatformInfo = StreamingModel(title: title, youtubeTrailer: trailer, overview: overview, tagline: tagline, platform: streamingPlatform, image: image)
                                    model = streamingPlatformInfo
                                }
                    break outerLoop
                }
            }

            
            
        } catch {
            print(error)
            return nil
        }
        return model
    }
    
    func performStreamingServicesRequest(for name: String) {
        var movieName = name
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
               let streamInfo = parseJSON(data: data, for: name) {
                DispatchQueue.main.async{
                    self.delegate?.didSelectMovie(self, streamInfo: streamInfo)
                }
            }
        })
        dataTask.resume()
    }
}
