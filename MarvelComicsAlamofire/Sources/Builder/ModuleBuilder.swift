//
//  ModuleBuilder.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 10/03/23.
//

import UIKit

protocol BuilderProtocol {
    static func createComicModule() -> UIViewController
    static func createDetailComicModule(comic: Comic) -> UIViewController
}

class ModuleBuilder: BuilderProtocol {
    static func createComicModule() -> UIViewController {
        let view = ComicViewController()
        let networkService = NetworkingService()
        let presenter = ComicPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }

    static func createDetailComicModule(comic: Comic) -> UIViewController {
        let view = ComicDetailViewController()
        let presenter = ComicDetailPresenter(view: view, comic: comic)
        view.presenter = presenter
        return view
    }
}
