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
            let image = decodedData.result[0].backdropURLs.original
            
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
            let streamingPlatformInfo = StreamingModel(youtubeTrailer: trailer, overview: overview, tagline: tagline, platform: streamingPlatform, image: image)
            return streamingPlatformInfo
        } catch {
            print(error)
            return nil
        }
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
               let streamInfo = parseJSON(data) {
                DispatchQueue.main.async{
                    self.delegate?.didSelectMovie(self, streamInfo: streamInfo)
                }
            }
        })
        dataTask.resume()
    }
}
