//
//  ViewController.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 08/03/23.
//

import UIKit

final class ComicViewController: UIViewController {

    var networkingService = NetworkingService()
    var comics: ComicDataWrapper?

    // MARK: - Outlets

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(ComicViewCell.self,
                                forCellWithReuseIdentifier: ComicViewCell.identifier)
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

    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .red
        return indicator
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
        showSpinner()
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
        view.addSubview(spinner)
    }

    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        spinner.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }

    private func showSpinner() {
        spinner.isHidden = false
        spinner.startAnimating()
    }

    private func hideSpinner() {
        spinner.isHidden = true
        spinner.stopAnimating()
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok!", style: .cancel))
        self.present(alert, animated: true)
    }

    private func fetchData() {
        networkingService.getData(
            urlRequest: networkingService.getUrlMarvel()
        ) { [weak self] result in
            switch result {
            case .success(let dataComics):
                self?.comics = dataComics
                DispatchQueue.main.async {
                    self?.hideSpinner()
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                switch error {
                case .invalidPath:
                    self?.showAlert(title: error.rawValue, message: "")
                case .decoding:
                    self?.showAlert(title: error.rawValue, message: "")
                }
            }
        }
    }
}

// MARK: - Extension

extension ComicViewController: UICollectionViewDataSource,
                               UICollectionViewDelegate,
                               UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return comics?.data.results.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ComicViewCell.identifier,
            for: indexPath
        ) as? ComicViewCell else { return UICollectionViewCell() }

        let comic = comics?.data.results
        cell.comic = comic?[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (view.frame.size.width / 1) - 20, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
