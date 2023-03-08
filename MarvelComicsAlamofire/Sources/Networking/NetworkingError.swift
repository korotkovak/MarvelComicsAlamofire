//
//  NetworkingError.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 08/03/23.
//

import Foundation

enum NetworkingError: String, Error {
    case invalidURL = "Неверный url"
    case errorService = "Ошибки сервера"
}

extension NetworkingError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(rawValue, comment: "")
    }
}
