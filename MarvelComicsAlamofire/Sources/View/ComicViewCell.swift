//
//  DetailViewCell.swift
//  MarvelComicsAlamofire
//
//  Created by Kristina Korotkova on 08/03/23.
//

import UIKit

class ComicViewCell: UICollectionViewCell {

    static let identifier = "DetailViewCell"

    // MARK: - Outlets

    private lazy var imageComic: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "Spider-Man")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 3
        label.text = "Spider-Man: Homecoming Spider-Man: Homecoming"
        return label
    }()

    private lazy var pagesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Number of pages: 120"
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
            make.top.equalTo(16)
            make.right.equalTo(-20)
        }

        pagesLabel.snp.makeConstraints { make in
            make.left.equalTo(imageComic.snp.right).offset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
    
}
