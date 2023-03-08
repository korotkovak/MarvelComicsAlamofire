//
//  ViewController.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 08/03/23.
//

import UIKit
import Alamofire

class ComicViewController: UIViewController {

    var networkingService: NetworkingService?
    var comics: ComicDataContainer?

    // MARK: - Outlets

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ComicViewCell.self, forCellWithReuseIdentifier: ComicViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "Marvel-Logo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        return imageView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }

    // MARK: - Setup

    private func commonInit() {
        setupView()
        setupHeirarchy()
        setupLayout()
        fetchData()
    }

    private func setupView() {
        view.backgroundColor = .black
        navigationItem.titleView = logoImageView
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    private func setupHeirarchy() {
        view.addSubview(collectionView)
    }

    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }

    private func fetchData() {
//        networkingService?.getData(urlRequest: networkingService?.getUrlMarvel(),
//                                   comletion: { result in
//            switch result {
//            case .success(let dataComics):
//                print(dataComics)
//                self.comics = dataComics
//            case .failure(let error):
//                print(error)
//            }
//        })

        let request = AF.request("https://api.jikan.moe/v4/manga/1/characters")
        request.responseDecodable(of: ComicDataContainer.self) { response in

            guard let comic = response.value else {
                return
            }
            self.comics = comic

//            self.tableView.reloadData()
        }
    }
}

// MARK: - Extension

extension ComicViewController: UICollectionViewDataSource,
                               UICollectionViewDelegate,
                               UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return comics?.results.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicViewCell.identifier,
                                                            for: indexPath) as? ComicViewCell
        else { return UICollectionViewCell() }
        let comic = comics?.results
        cell.comic = comic?[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (view.frame.size.width / 1) - 20,
               height: 150)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
