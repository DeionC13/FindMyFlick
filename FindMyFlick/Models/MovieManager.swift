//
//  MovieManager.swift
//  FindMyFlick
//
//  Created by Deion caldwell on 1/26/23.
//

import Foundation

protocol MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, movie: MovieModel)
    func didFailWithError(error: Error)
}
struct MovieManager {
    var delegate: MovieManagerDelegate?
    
    let baseURL = "https://imdb-api.com/en/API/SearchMovie/k_bgm28e4l/"
    
    func fetchMovie(for userSearch: String) {
        let newSearch = userSearch.replacingOccurrences(of: " ", with: "%20")
        
        let urlString = "\(baseURL)\(newSearch)"
        
        performRequest(for: urlString)
    }
    func performRequest(for urlString: String){
        
     
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    
                    if let movie = self.parseJSON(safeData) {
                        
                        self.delegate?.didUpdateMovie(self, movie: movie)
                    }
                }
            }
            task.resume()
        }
       
    }
    
    func parseJSON(_ data: Data) -> MovieModel?{
        let decoder = JSONDecoder()
    
        do {
                let decodedData = try decoder.decode(MovieData.self, from: data)
                let name = decodedData.results[0].title
                let description = decodedData.results[0].description
                let results = decodedData.results
                
            
                
            let movie = MovieModel(movieName: name, movieDescription: description, results: results)
                return movie
         
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
            
        }
        
    }
}
