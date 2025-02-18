//
//  FavoriteMoviesCell.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import UIKit

class FavoriteMovieTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let imageRatio: CGFloat = 281.0/500.0
        static let removeButtonSize: CGFloat = 30.0
        static let padding: CGFloat = 16.0
        
        static let removeButtonText: String = "Remover"
    }
    
    static let identifier = "FavoriteMovieTableViewCell"
    
    private let backdropImageView: CustomImageView = {
        let image = CustomImageView(frame: .zero)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.slash"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.removeButtonText, for: .normal)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var removeButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        selectionStyle = .none
        backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        selectionStyle = .none
        backgroundColor = .black
    }
    
    private func setup() {
        contentView.addSubview(backdropImageView)
        contentView.addSubview(removeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)

        removeButton.addTarget(self, action: #selector(handleRemove), for: .touchUpInside)

        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalTo: backdropImageView.widthAnchor, multiplier: Constants.imageRatio),

            removeButton.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: Constants.padding / 2),
            removeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            removeButton.heightAnchor.constraint(equalToConstant: Constants.removeButtonSize),

            titleLabel.topAnchor.constraint(equalTo: removeButton.bottomAnchor, constant: Constants.padding / 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),

            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.padding / 4),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(Constants.padding * 2))
        ])
    }
    
    func configure(with movie: MovieDetailsConfig) {
        if let image = movie.image {
            backdropImageView.image = image
        } else if let url = movie.imageURL {
            backdropImageView.loadImage(url)
        } else {
            backdropImageView.image = nil
        }

        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
    }
    
    @objc private func handleRemove() {
        removeButtonTapped?()
    }
}
