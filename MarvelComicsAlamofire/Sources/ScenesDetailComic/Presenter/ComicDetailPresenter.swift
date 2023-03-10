//
//  ComicDetailPresenter.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 10/03/23.
//

import Foundation

protocol ComicDetailViewProtocol: AnyObject {
    func fillSettings(with model: Comic?)
}

protocol ComicDetailPresenterProtocol: AnyObject {
    init(view: ComicDetailViewProtocol, comic: Comic)
    func setComic()
}

final class ComicDetailPresenter: ComicDetailPresenterProtocol {
    weak var view: ComicDetailViewProtocol?
    var comic: Comic?

    init(view: ComicDetailViewProtocol, comic: Comic) {
        self.view = view
        self.comic = comic
    }

    func setComic() {
        view?.fillSettings(with: comic)
    }
}
