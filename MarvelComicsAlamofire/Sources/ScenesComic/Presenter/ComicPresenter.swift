//
//  ComicPresenter.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 10/03/23.
//

import Foundation

protocol ComicViewProtocol: AnyObject {
    func succes()
    func failure(error: NetworkingError)
}

protocol ComicViewCellProtocol: AnyObject {
    func fillSettings(with model: Comic?)
}

protocol ComicViewPresenterProtocol: AnyObject {
    var comics: ComicDataWrapper? { get set }
    var filterComic: [Comic] { get set }
    init(view: ComicViewProtocol,
         networkService: NetworkingServiceProtocol)
    func fetchData()
}

final class ComicPresenter: ComicViewPresenterProtocol {
    weak var view: ComicViewProtocol?
    let networkService: NetworkingServiceProtocol

    var comics: ComicDataWrapper?
    var filterComic = [Comic]()

    required init(view: ComicViewProtocol,
                  networkService: NetworkingServiceProtocol) {
        self.view = view
        self.networkService = networkService
        fetchData()
    }

    func fetchData() {
        networkService.getData(
            urlRequest: networkService.getUrlMarvel()
        ) { [weak self] result in
            switch result {
            case .success(let dataComics):
                self?.comics = dataComics
                self?.view?.succes()
            case .failure(let error):
                self?.view?.failure(error: error)
            }
        }
    }
}
