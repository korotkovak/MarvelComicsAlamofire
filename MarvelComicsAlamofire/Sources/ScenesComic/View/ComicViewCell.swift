//
//  DetailViewCell.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 08/03/23.
//

import UIKit

final class ComicViewCell: UICollectionViewCell, ComicViewCellProtocol {

    static let identifier = "ComicViewCell"

    // MARK: - Outlets

    private lazy var imageComic: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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

    private lazy var pagesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        return label
    }()

    // MARK: - Initial

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func commonInit() {
        setupView()
        setupHeirarchy()
        setupLayout()
    }

    private func setupView() {
        contentView.backgroundColor = UIColor().hexStringToUIColor(hex: "161616")
    }

    private func setupHeirarchy() {
        contentView.addSubview(imageComic)
        contentView.addSubview(titleLabel)
        contentView.addSubview(pagesLabel)
    }

    private func setupLayout() {
        imageComic.snp.makeConstraints { make in
            make.left.height.equalTo(self)
            make.width.equalTo(110)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageComic.snp.right).offset(12)
            make.top.equalTo(12)
            make.right.equalTo(-20)
        }

        pagesLabel.snp.makeConstraints { make in
            make.left.equalTo(imageComic.snp.right).offset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }

    // MARK: - Method

    func fillSettings(with model: Comic?) {
        guard let model = model else { return }

        titleLabel.text = model.title

        if model.pageCount == 0 || model.pageCount == nil {
            pagesLabel.text = "Number of pages: is unknown"
        } else if let page = model.pageCount {
            pagesLabel.text = "Number of pages: \(page)"
        }

        let queue = DispatchQueue(label: "ComicViewCell")
        queue.async {
            guard let imagePath = model.thumbnail.path,
                  let imageFormat = model.thumbnail.format,
                  let imageURL = URL(string: "\(imagePath).\(imageFormat)"),
                  let imageData = try? Data(contentsOf: imageURL)
            else { return }

            DispatchQueue.main.async {
                self.imageComic.image = UIImage(data: imageData)
            }
        }
    }
}
