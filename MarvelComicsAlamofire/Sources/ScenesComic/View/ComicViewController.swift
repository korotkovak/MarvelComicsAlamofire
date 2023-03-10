//
//  ViewController.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 08/03/23.
//

import UIKit

// MARK: - Constants

fileprivate enum Strings {
    static let logoMarvel = "Marvel-Logo"
    static let searchTextFieldPlaceholder = "Search comic"
    static let searchButtonSetTitle = "Search"
    static let cancelButtonSetTitle = "Cancel filter"
    static let cancelAlert = UIAlertAction(title: "Ok!", style: .cancel)
    static let alertNoMatchesFound = "No matches found"
}

fileprivate enum Images {
    static let backButton = UIImage(named: "Back-Arrow")
    static let imageLeftIconInSearch = UIImage(systemName: "magnifyingglass")
}

// MARK: - ComicViewController

final class ComicViewController: UIViewController, ComicViewProtocol {

    var presenter: ComicViewPresenterProtocol?
    var isFiltered = false

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
        let image = UIImage(named: Strings.logoMarvel)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        return imageView
    }()

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.placeholder = Strings.searchTextFieldPlaceholder
        textField.backgroundColor = Colors.gray
        textField.textAlignment = .left
        return textField
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.searchButtonSetTitle, for: .normal)
        button.backgroundColor = Colors.red
        button.setTitleColor(Colors.white, for: .normal)
        button.titleLabel?.font = Fonts.semiboldOfSize16
        button.addTarget(self, action: #selector(searchButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    private lazy var cancelFilterButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.cancelButtonSetTitle, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.red.cgColor
        button.setTitleColor(Colors.white, for: .normal)
        button.titleLabel?.font = Fonts.semiboldOfSize16
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.addArrangedSubview(searchButton)
        stack.addArrangedSubview(cancelFilterButton)
        return stack
    }()

    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = Colors.red
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
        setupIcons()
        setupKeyboard()
        setupLayout()
        showSpinner()
    }

    private func setupView() {
        let backBarButton = UIBarButtonItem(title: "",
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        view.backgroundColor = Colors.black
        navigationController?.navigationBar.backIndicatorImage = Images.backButton
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = Images.backButton
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.navigationBar.tintColor = Colors.white
        navigationItem.titleView = logoImageView
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                               for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    private func setupHeirarchy() {
        view.addSubview(searchTextField)
        view.addSubview(stack)
        view.addSubview(collectionView)
        view.addSubview(spinner)
    }

    private func setupIcons() {
        if let image = Images.imageLeftIconInSearch {
            searchTextField.setLeftIcon(image)
        }
    }

    private func setupKeyboard() {
        searchTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
    }

    private func setupLayout() {
        searchTextField.snp.makeConstraints { make in
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(50)
        }

        searchButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        cancelFilterButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        stack.snp.makeConstraints { make in
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
            make.top.equalTo(searchTextField.snp.bottom).offset(14)
        }

        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(stack.snp.bottom).offset(20)
        }

        spinner.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }

    // MARK: - Method

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

        alert.addAction(Strings.cancelAlert)
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

    // MARK: - Action

    @objc private func searchButtonTapped() {
        guard let searchText = searchTextField.text,
              !searchText.isEmpty,
        let filterComic = presenter?.filterComic else { return }

        searchTextField.text = ""

        if filterComic.isEmpty {
            showAlert(title: Strings.alertNoMatchesFound, message: "")
            isFiltered = false
        } else {
            collectionView.reloadData()
            isFiltered = false
        }
    }

    @objc private func cancelButtonTapped() {
        guard presenter?.filterComic != nil else { return }
        presenter?.filterComic.removeAll()
        collectionView.reloadData()
        isFiltered = false
    }
}

// MARK: - UICollectionViewDataSource

extension ComicViewController: UICollectionViewDataSource,
                               UICollectionViewDelegate,
                               UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if let filterComic = presenter?.filterComic, !filterComic.isEmpty {
            return filterComic.count
        }
        return isFiltered ? 0 : presenter?.comics?.data.results.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let item = collectionView.dequeueReusableCell(
            withReuseIdentifier: ComicViewCell.identifier,
            for: indexPath
        ) as? ComicViewCell else { return UICollectionViewCell() }

        if let filterComic = presenter?.filterComic, !filterComic.isEmpty {
            item.fillSettings(with: filterComic[indexPath.row])
        } else if let comic = presenter?.comics?.data.results {
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

        if let filterComic = presenter?.filterComic, !filterComic.isEmpty {
            let detailViewController = ModuleBuilder.createDetailComicModule(
                comic: filterComic[indexPath.row]
            )
            navigationController?.pushViewController(detailViewController,
                                                     animated: true)
        } else if let comic = presenter?.comics?.data.results[indexPath.row] {
            let detailViewController = ModuleBuilder.createDetailComicModule(
                comic: comic
            )
            navigationController?.pushViewController(detailViewController,
                                                     animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension ComicViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text {
            filterText(text)
        }
        return true
    }

    func filterText(_ query: String) {
        guard let comics = presenter?.comics?.data.results else { return }
        guard presenter?.filterComic != nil else { return }

        presenter?.filterComic.removeAll()

        for comic in comics {
            guard let titleComic = comic.title else { return }
            if titleComic.lowercased().starts(with: query.lowercased()) {
                presenter?.filterComic.append(comic)
            }
            isFiltered = true
        }
    }

    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
