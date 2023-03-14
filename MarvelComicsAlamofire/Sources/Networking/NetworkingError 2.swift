//
//  NetworkingError.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 08/03/23.
//

import Foundation

enum NetworkingError: String, Error {
    case invalidPath = "Invalid Path"
    case decoding = "There was an error decoding the type"
}

extension NetworkingError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(rawValue, comment: "")
    }
}
