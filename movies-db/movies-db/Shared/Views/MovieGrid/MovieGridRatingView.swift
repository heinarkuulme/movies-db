//
//  MovieGridRatingView.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

class MovieGridRatingView: UIView {
    
    private enum Constants {
        static let starSize: CGFloat = 12.0
        static let spacing: CGFloat = 4.0
        static let ratingSpacing: CGFloat = 7.0
        static let borderWidth: CGFloat = 1.0
        
        static let ratingImage: String = "star.fill"
    }
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: Constants.ratingImage)
        return imageView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [starImageView, ratingLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constants.spacing
        stack.alignment = .center
        return stack
    }()
    
    private var rating: Float = 0.0
    private let fillLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        layer.borderWidth = Constants.borderWidth
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: Constants.starSize),
            starImageView.heightAnchor.constraint(equalToConstant: Constants.starSize)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        updateFillLayer()
    }

    private func updateFillLayer() {
        let percentage = CGFloat(rating / 10.0)
        let fillWidth = bounds.width * percentage
        fillLayer.frame = CGRect(x: 0, y: 0, width: fillWidth, height: bounds.height)
        fillLayer.backgroundColor = fillColor(for: rating).cgColor
        fillLayer.cornerRadius = bounds.height / 2
        if fillLayer.superlayer == nil {
            layer.insertSublayer(fillLayer, at: 0)
        }
    }
    
    func configure(with rating: Float) {
        self.rating = rating
        ratingLabel.text = String(format: "%.1f", rating)
        setNeedsLayout()
    }

    private func fillColor(for rating: Float) -> UIColor {
        if rating >= 7.0 {
            return UIColor(hex: "#56db78")
        } else if rating >= 4.0 {
            return UIColor(hex: "#e3ac56")
        } else {
            return UIColor(hex: "#ed5e55")
        }
    }
}
