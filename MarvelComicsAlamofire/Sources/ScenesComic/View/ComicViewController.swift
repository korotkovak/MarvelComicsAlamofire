//
//  ViewController.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 08/03/23.
//

import UIKit

final class ComicViewController: UIViewController, ComicViewProtocol {

    var presenter: ComicViewPresenterProtocol?

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
    }

    private func setupView() {
        let backButton = UIImage(named: "Back-Arrow")
        let backBarButton = UIBarButtonItem(title: "",
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        view.backgroundColor = .black
        navigationController?.navigationBar.backIndicatorImage = backButton
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButton
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.navigationBar.tintColor = .white
        navigationItem.titleView = logoImageView
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                               for: .default)
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

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok!", style: .cancel))
        self.present(alert, animated: true)
    }

    func succes() {
        hideSpinner()
        collectionView.reloadData()
    }

    func failure(error: NetworkingError) {
        switch error {
        case .invalidPath:
            showAlert(title: error.rawValue, message: "")
        case .decoding:
            showAlert(title: error.rawValue, message: "")
        }
    }
}

// MARK: - Extension

extension ComicViewController: UICollectionViewDataSource,
                               UICollectionViewDelegate,
                               UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return presenter?.comics?.data.results.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let item = collectionView.dequeueReusableCell(
            withReuseIdentifier: ComicViewCell.identifier,
            for: indexPath
        ) as? ComicViewCell else { return UICollectionViewCell() }

        if let comic = presenter?.comics?.data.results {
            item.fillSettings(with: comic[indexPath.row])
        }
        return item
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

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let comic = presenter?.comics?.data.results[indexPath.row] else { return }
        let detailViewController = ModuleBuilder.createDetailComicModule(comic: comic)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
