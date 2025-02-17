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
    
    private enum Constants {
        static let imageCornerRadius: CGFloat = 10
        static let imageRatio: CGFloat = 750.0/500.0
        static let favoriteContainerSize: CGFloat = 38.0
        static let favoriteSize: CGFloat = 24.0
        static let ratingBarHeight: CGFloat = 20.0
        static let padding: CGFloat = 4.0
        static let textSpacing: CGFloat = 1.0
        static let ratingSpacing: CGFloat = 7.0
        static let borderWidth: CGFloat = 1.0
        
        static let favoritedImage: String = "heart.fill"
        static let favoriteImage: String = "heart"
    }
    
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
        image.layer.cornerRadius = Constants.imageCornerRadius
        return image
    }()
    
    private lazy var favoriteContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.85)
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.favoriteContainerSize / 2
        view.layer.borderWidth = Constants.borderWidth
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.75).cgColor
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonTapped))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .init(hex: "#d1453b").withAlphaComponent(0.8)
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
    
    weak var delegate: MovieGridCellDelegate?
    private var movie: MovieGridConfig?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) não foi implementado")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteButton.transform = .identity
        favoriteContainerView.transform = .identity
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
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: Constants.imageRatio),

            favoriteContainerView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: -Constants.padding),
            favoriteContainerView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: -Constants.padding),
            favoriteContainerView.widthAnchor.constraint(equalToConstant: Constants.favoriteContainerSize),
            favoriteContainerView.heightAnchor.constraint(equalToConstant: Constants.favoriteContainerSize),

            favoriteButton.centerXAnchor.constraint(equalTo: favoriteContainerView.centerXAnchor),
            favoriteButton.centerYAnchor.constraint(equalTo: favoriteContainerView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: Constants.favoriteSize),
            favoriteButton.heightAnchor.constraint(equalToConstant: Constants.favoriteSize),

            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: Constants.padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
            
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.textSpacing),
            releaseDateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            releaseDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),

            ratingBarView.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: Constants.ratingSpacing),
            ratingBarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            ratingBarView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
            ratingBarView.heightAnchor.constraint(equalToConstant: Constants.ratingBarHeight),
            ratingBarView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -Constants.padding)
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
        let imageName = isFavorited ? Constants.favoritedImage : Constants.favoriteImage
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func favoriteButtonTapped() {
        guard var movie = movie else { return }
        movie.isFavorited.toggle()

        UIView.animate(withDuration: 0.1, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.favoriteContainerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.favoriteButton.transform = .identity
                self.favoriteContainerView.transform = .identity
            }, completion: { _ in
                self.updateFavoriteState(isFavorited: movie.isFavorited)
                self.delegate?.movieGridCell(self, didToggleFavoriteFor: movie)
            })
        })
    }
}
