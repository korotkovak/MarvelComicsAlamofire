//
//  ComicModel.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 08/03/23.
//

import Foundation

struct ComicDataWrapper: Codable {
    var data: ComicDataContainer
}

struct ComicDataContainer: Codable {
    var count: Int?
    var results: [Comic]
}

struct Comic: Codable {
    var id: Int
    var title: String?
    var description: String?
    var pageCount: Int?
//    var dates: [ComicDate]?
    var prices: [ComicPrice]?
    var thumbnail: Image
    var creators: CreatorList
}

struct Image: Codable {
    var path: String?
    var format: String?

    enum CodingKeys: String, CodingKey {
        case format = "extension"
        case path
    }
}

//struct ComicDate: Codable {
//    var type: String?
//    var date: Date?
//}

struct ComicPrice: Codable {
    var price: Float?
}

struct CreatorList: Codable {
    var items: [CreatorSummary]?
}

struct CreatorSummary: Codable {
    var name: String?
    var role: String?
}
