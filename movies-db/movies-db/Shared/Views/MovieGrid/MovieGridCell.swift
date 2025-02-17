//
//  MovieGridCell.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

protocol MovieGridCellDelegate: AnyObject {
    func movieGridCell(_ cell: MovieGridCell, didToggleFavoriteFor movie: MovieGridConfig)
}

class MovieGridCell: UICollectionViewCell {
    
    weak var delegate: MovieGridCellDelegate?
    private var movie: MovieGridConfig?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var coverImageView: CustomImageView = {
        let image = CustomImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8//Constants.imageCornerRadius
        return image
    }()
    
    private lazy var favoriteContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.85)
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.75).cgColor
        return view
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed.withAlphaComponent(0.8)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .init(hex: "#69696C")
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var ratingBarView: MovieGridRatingView = {
        let view = MovieGridRatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) não foi implementado")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(coverImageView)
        containerView.addSubview(favoriteContainerView)
        favoriteContainerView.addSubview(favoriteButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(releaseDateLabel)
        containerView.addSubview(ratingBarView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            coverImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: 750.0/500.0),

            favoriteContainerView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: -4),
            favoriteContainerView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: -4),
            favoriteContainerView.widthAnchor.constraint(equalToConstant: 32),
            favoriteContainerView.heightAnchor.constraint(equalToConstant: 32),

            favoriteButton.centerXAnchor.constraint(equalTo: favoriteContainerView.centerXAnchor),
            favoriteButton.centerYAnchor.constraint(equalTo: favoriteContainerView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            releaseDateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            releaseDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),

            ratingBarView.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 7),
            ratingBarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            ratingBarView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            ratingBarView.heightAnchor.constraint(equalToConstant: 20),
            ratingBarView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -4)
        ])
    }
    
    func configure(with movie: MovieGridConfig) {
        self.movie = movie
        
        coverImageView.loadImage(movie.coverURL)
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        ratingBarView.configure(with: movie.rating)
        updateFavoriteState(isFavorited: movie.isFavorited)
    }
    
    private func updateFavoriteState(isFavorited: Bool) {
        let imageName = isFavorited ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func favoriteButtonTapped() {
        guard var movie = movie else { return }
        movie.isFavorited.toggle()

        UIView.animate(withDuration: 0.1, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.favoriteContainerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.favoriteButton.transform = .identity
                self.favoriteContainerView.transform = .identity
            }
        })
        updateFavoriteState(isFavorited: movie.isFavorited)
        delegate?.movieGridCell(self, didToggleFavoriteFor: movie)
    }
}
