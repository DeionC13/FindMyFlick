//
//  NetworkingManager.swift
//  FindMyFlick
//
//  Created by Deion caldwell on 2/2/23.
//

import Foundation

struct NetworkingManager {
    var urlString: String
    
    func performRequest(for urlString: String)  -> Data? {
        var sentData: Data?
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    return
                }
                if let safeData = data {
                    sentData = safeData
                }
                
            }
            task.resume()
            
        }
        
        return sentData
    }
}
