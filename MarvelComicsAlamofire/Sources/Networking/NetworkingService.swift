//
//  NetworkingService.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 08/03/23.
//

import Foundation
import CryptoKit
import Alamofire

class NetworkingService {
    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }

    func getUrlMarvel() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "gateway.marvel.com"
        components.path = "/v1/public/comics"

        let publicKey = "7b8e485606503dda985b5811626331c2"
        let privateKey = "9f71fa61e8a9dec9e7904cd00c41ded68e76d4cf"
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(string: "\(ts)\(privateKey)\(publicKey)")

        let queryItemLimit = URLQueryItem(name: "limit", value: "20")
        let queryItemFormatType = URLQueryItem(name: "formatType", value: "comic")
        let queryItemTs = URLQueryItem(name: "ts", value: ts)
        let queryItemApiKey = URLQueryItem(name: "apikey", value: publicKey)
        let queryItemHash = URLQueryItem(name: "hash", value: hash)

        components.queryItems = [queryItemLimit,
                                 queryItemFormatType,
                                 queryItemTs,
                                 queryItemApiKey,
                                 queryItemHash]

        let url = components.url
        print(url)
        return url
    }

    func getData(urlRequest: URL?,
                        comletion: @escaping (Result<ComicDataContainer,
                                              NetworkingError>) -> Void) {
        guard let url = urlRequest else {
            comletion(.failure(.invalidURL))
            return
        }

        let queue = DispatchQueue.global()
        queue.async {
            _ = AF.request(url)
                .validate()
                .responseDecodable(of: ComicDataContainer.self) { response in
                guard let comic = response.value else {
                    comletion(.failure(.errorService))
                    return
                }
                comletion(.success(comic))
            }
        }
    }
}
