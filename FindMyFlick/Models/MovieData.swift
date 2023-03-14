//
//  MovieData.swift
//  FindMyFlick
//
//  Created by Deion caldwell on 1/26/23.
//

import Foundation

struct MovieData: Codable {
    let results: [Results]
}

struct Results: Codable {
    var id: String
    var title: String
    var description: String
    var image: String
}
