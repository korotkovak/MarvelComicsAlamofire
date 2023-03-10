//
//  DetailViewController.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 09/03/23.
//

import UIKit

final class ComicDetailViewController: UIViewController, ComicDetailViewProtocol {

    var presenter: ComicDetailPresenterProtocol?

    // MARK: - Outlets

    private lazy var imageComic: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
    }()

    private lazy var editorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()

    private lazy var editorRoleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private lazy var stackEditor: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        stack.addArrangedSubview(editorNameLabel)
        stack.addArrangedSubview(editorRoleLabel)
        return stack
    }()

    private lazy var writerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()

    private lazy var writerRoleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        return label
    }()

    private lazy var stackWriter: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5
        stack.addArrangedSubview(writerNameLabel)
        stack.addArrangedSubview(writerRoleLabel)
        return stack
    }()

    private lazy var pagesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        return label
    }()

    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .red
        return indicator
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(pagesLabel)
        stack.addArrangedSubview(stackEditor)
        stack.addArrangedSubview(stackWriter)
        return stack
    }()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.isDirectionalLockEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.addSubview(contentView)
        return scroll
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.addSubview(imageComic)
        view.addSubview(titleLabel)
        view.addSubview(stack)
        view.addSubview(spinner)
        return view
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
        presenter?.setComic()
    }

    private func setupView() {
        view.backgroundColor = .black
    }

    private func setupHeirarchy() {
        view.addSubview(scrollView)
    }

    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(scrollView.contentLayoutGuide)
            make.top.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }

        imageComic.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(400)
        }

        spinner.snp.makeConstraints { make in
            make.center.equalTo(imageComic.snp.center)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(imageComic.snp.bottom).offset(20)
        }

        stack.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalTo(scrollView)
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

    func fillSettings(with model: Comic?) {
        guard let model = model else { return }
        
        DispatchQueue.main.async {
            self.titleLabel.text = model.title
            self.descriptionLabel.text = model.description

            if model.pageCount == 0 || model.pageCount == nil {
                self.pagesLabel.text = "Number of pages: is unknown"
            } else if let page = model.pageCount {
                self.pagesLabel.text = "Number of pages: \(page)"
            }

            guard let creators = model.creators.items else { return }

            for creator in creators {
                if creator.role == "editor" {
                    self.editorRoleLabel.text = creator.role
                    self.editorNameLabel.text = creator.name
                }

                if creator.role == "writer" {
                    self.writerRoleLabel.text = creator.role
                    self.writerNameLabel.text = creator.name
                }
            }
        }

        showSpinner()

        let queue = DispatchQueue(label: "DetailViewController")
        queue.async {
            guard let imagePath = model.thumbnail.path,
                  let imageFormat = model.thumbnail.format,
                  let imageURL = URL(string: "\(imagePath).\(imageFormat)"),
                  let imageData = try? Data(contentsOf: imageURL)
            else { return }

            DispatchQueue.main.async {
                self.imageComic.image = UIImage(data: imageData)
                self.hideSpinner()
            }
        }
    }
}
