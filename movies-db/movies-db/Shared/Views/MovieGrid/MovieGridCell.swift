//
//  MovieGridCell.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

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
        static let calendarSize: CGFloat = 20.0
        
        static let favoritedImage: String = "heart.fill"
        static let favoriteImage: String = "heart"
        static let releaseDateImage: String = "calendar"
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
        return view
    }()
    
    private lazy var favoriteIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .init(hex: "#d1453b").withAlphaComponent(0.8)
        return image
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
    
    private lazy var releaseDateImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .init(hex: "#99999e")
        imageView.image = UIImage(systemName: Constants.releaseDateImage)
        return imageView
    }()
    
    private lazy var ratingBarView: MovieGridRatingView = {
        let view = MovieGridRatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        favoriteIcon.transform = .identity
        favoriteContainerView.transform = .identity
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(coverImageView)
        containerView.addSubview(favoriteContainerView)
        favoriteContainerView.addSubview(favoriteIcon)
        containerView.addSubview(titleLabel)
        containerView.addSubview(releaseDateLabel)
        containerView.addSubview(releaseDateImage)
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

            favoriteIcon.centerXAnchor.constraint(equalTo: favoriteContainerView.centerXAnchor),
            favoriteIcon.centerYAnchor.constraint(equalTo: favoriteContainerView.centerYAnchor),
            favoriteIcon.widthAnchor.constraint(equalToConstant: Constants.favoriteSize),
            favoriteIcon.heightAnchor.constraint(equalToConstant: Constants.favoriteSize),

            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: Constants.padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
            
            releaseDateImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.textSpacing),
            releaseDateImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            releaseDateImage.widthAnchor.constraint(equalToConstant: Constants.calendarSize),
            releaseDateImage.heightAnchor.constraint(equalToConstant: Constants.calendarSize),

            releaseDateLabel.centerYAnchor.constraint(equalTo: releaseDateImage.centerYAnchor),
            releaseDateLabel.leadingAnchor.constraint(equalTo: releaseDateImage.trailingAnchor, constant: Constants.padding),
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
        favoriteIcon.image = UIImage(systemName: imageName)
    }
   
}
