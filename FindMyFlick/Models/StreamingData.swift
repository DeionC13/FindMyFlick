//
//  StreamingData.swift
//  FindMyFlick
//
//  Created by Deion caldwell on 2/2/23.
//

import Foundation


struct StreamingData: Codable {
    let result: [Result]
}

struct Result: Codable {
//    let type: ResultType
    let title, overview: String
    let streamingInfo: ResultStreamingInfo
//    let cast: [String]
//    let year: Int?
//    let advisedMinimumAudienceAge: Int
//    let imdbID: String
//    let imdbRating, imdbVoteCount, tmdbID, tmdbRating: Int
//    let originalTitle, backdropPath: String
    let backdropURLs: BackdropURLs
//    let genres: [Genre]
//    let originalLanguage: OriginalLanguage
//    let countries: [String]
//    let directors: [String]?
//    let runtime: Int?
//    let youtubeTrailerVideoID: String
    let youtubeTrailerVideoLink: String
//    let posterPath: String
//    let posterURLs: PosterURLs
    let tagline: String
//    let firstAirYear, lastAirYear: Int?
//    let creators: [Any?]?
//    let status: Status?
//    let seasonCount, episodeCount: Int?
//    let episodeRuntimes: [Int]?
//    let seasons: [Season]?
}

// MARK: - BackdropURLs
struct BackdropURLs: Codable {
    let the1280, the300, the780, original: String?
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

enum OriginalLanguage: Codable {
    case en
    case hi
    case it
    case ko
}

// MARK: - PosterURLs
struct PosterURLs: Codable {
    let the154, the185, the342, the500: String?
    let the780, the92, original: String?
}

// MARK: - Season
struct Season: Codable {
    let type, title, overview: String
    let streamingInfo: EpisodeStreamingInfo
//    let cast: [Any?]
    let firstAirYear, lastAirYear: Int
    let youtubeTrailerVideoID: String
    let youtubeTrailerVideoLink: String
    let posterPath: String
    let posterURLs: PosterURLs
    let episodes: [Episode]
}

// MARK: - Episode
struct Episode: Codable {
    let type: EpisodeType
    let title, overview: String
    let streamingInfo: EpisodeStreamingInfo
    let cast: [String]
    let year: Int
//: Codable: Codable: Codable    let runtime: Int
    let stillPath: String
    let stillURLs: StillURLs
    let imdbID: ImdbID
    let imdbRating, imdbVoteCount, tmdbRating: Int
    let youtubeTrailerVideoID, youtubeTrailerVideoLink: String
}

enum ImdbID: Codable {
    case empty
    case tt10338680
}

// MARK: - StillURLs
struct StillURLs: Codable {
    let the185, the300, the92, original: String?
}

// MARK: - EpisodeStreamingInfo
struct EpisodeStreamingInfo: Codable {
    let us: PurpleUs?
}

// MARK: - PurpleUs
struct PurpleUs: Codable {
    let disney: [Apple]
}

// MARK: - Apple
struct Apple: Codable {
//    let type: AppleType
//    let quality: Quality
    let addOn: String
    let link: String
    let watchLink: String
    let audios: [Audio]?
    let subtitles: [Subtitle]?
//    let price: Price?
    let leaving: Int
}

// MARK: - Audio
struct Audio: Codable {
    let language, region: String
}

// MARK: - Price
struct Price: Codable {
    let amount: String
    let currency: Currency
    let formatted: Formatted
}

enum Currency: Codable {
    case usd
}

enum Formatted: Codable {
    case the1499Usd
    case the399Usd
    case the999Usd
}

enum Quality: Codable {
    case empty
    case hd
    case sd
    case uhd
}

// MARK: - Subtitle
struct Subtitle: Codable {
    let locale: Audio
    let closedCaptions: Bool
}

enum AppleType: Codable {
    case buy
    case rent
    case subscription
}

enum EpisodeType: Codable {
    case episode
}

// MARK: - Status
struct Status: Codable {
    let statusCode: Int
    let statusText: String
}

// MARK: - ResultStreamingInfo
struct ResultStreamingInfo: Codable {
    let us: FluffyUs?
}

// MARK: - FluffyUs
struct FluffyUs: Codable {
    let hulu, apple, netflix, prime, hbo: [Apple]?
    let paramount, disney, peacock: [Apple]?
}

enum ResultType: Codable {
    case movie
    case series
}
