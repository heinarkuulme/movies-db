//
//  MovieDetailsView.swift
//  movies-db
//
//  Created by Heinar Kuulme on 17/02/25.
//

import UIKit

struct MovieDetailsConfig {
    
    let title: String?
    let originalTitle: String?
    let releaseDate: String?
    let duration: String?
    let budget: String?
    let revenue: String?
    let vote: String?
    let overview: String?
    var id: Int?
    let imageURL: URL?
    var image: UIImage?
    var isFavorited: Bool
    
    init(title: String?,
         originalTitle: String?,
         releaseDate: String?,
         duration: String?,
         budget: String?,
         revenue: String?,
         vote: String?,
         overview: String?,
         id: Int?,
         imageURL: URL?,
         image: UIImage?,
         isFavorited: Bool = false) {
        self.title = title
        self.originalTitle = originalTitle
        self.releaseDate = releaseDate
        self.duration = duration
        self.budget = budget
        self.revenue = revenue
        self.vote = vote
        self.overview = overview
        self.id = id
        self.imageURL = imageURL
        self.image = image
        self.isFavorited = isFavorited
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title as Any,
            "originalTitle": originalTitle as Any,
            "releaseDate": releaseDate as Any,
            "duration": duration as Any,
            "budget": budget as Any,
            "revenue": revenue as Any,
            "vote": vote as Any,
            "overview": overview as Any,
            "id": id as Any,
            "isFavorited": isFavorited as Any
        ]

        if let imageURL = imageURL {
            dict["imageURL"] = imageURL.absoluteString
        }

        if let image = image, let imageData = image.jpegData(compressionQuality: 1.0) {
            dict["image"] = imageData
        }

        return dict
    }

    init?(dictionary: [String: Any]) {
        guard let title = dictionary["title"] as? String,
              let originalTitle = dictionary["originalTitle"] as? String,
              let releaseDate = dictionary["releaseDate"] as? String,
              let duration = dictionary["duration"] as? String,
              let budget = dictionary["budget"] as? String,
              let revenue = dictionary["revenue"] as? String,
              let vote = dictionary["vote"] as? String,
              let overview = dictionary["overview"] as? String,
              let id = dictionary["id"] as? Int,
              let isFavorited = dictionary["isFavorited"] as? Bool else {
            return nil
        }

        var imageURL: URL? = nil
        if let imageURLString = dictionary["imageURL"] as? String {
            imageURL = URL(string: imageURLString)
        }

        var image: UIImage? = nil
        if let imageData = dictionary["image"] as? Data {
            image = UIImage(data: imageData)
        }

        self.init(
            title: title,
            originalTitle: originalTitle,
            releaseDate: releaseDate,
            duration: duration,
            budget: budget,
            revenue: revenue,
            vote: vote,
            overview: overview,
            id: id,
            imageURL: imageURL,
            image: image,
            isFavorited: isFavorited
        )
    }
}

class MovieDetailsView: BaseViewController {
    
    private enum Constants {
        static let favoriteContainerSize: CGFloat = 50.0
        static let favoriteSize: CGFloat = 40.0
        static let borderWidth: CGFloat = 1.0
        static let padding: CGFloat = 16.0
        static let imageRatio: CGFloat = 281.0/500.0
        static let statsHeight: CGFloat = 25.0
        static let iconsSize: CGFloat = 30.0
        
        static let favoritedImage: String = "heart.fill"
        static let favoriteImage: String = "heart"
        static let releaseDateImage: String = "calendar.circle"
        static let titleImage: String = "popcorn.circle"
        static let durationImage: String = "timer.circle"
        
        static let budgetText: String = "Custo"
        static let revenueText: String = "Arrecação"
        static let voteText: String = "Nota"

    }
    
    //MARK: - Outlets
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backdropImageView: CustomImageView = {
        let image = CustomImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var originalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#69696C")
        label.numberOfLines = 0
        return label
    }()

    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#69696C")
        label.numberOfLines = 0
        return label
    }()

    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#69696C")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var originalTitleStack: UIStackView = {
        return makeInfoRow(iconName: Constants.titleImage, label: originalTitleLabel)
    }()

    private lazy var releaseDateStack: UIStackView = {
        return makeInfoRow(iconName: Constants.releaseDateImage, label: releaseDateLabel)
    }()

    private lazy var durationStack: UIStackView = {
        return makeInfoRow(iconName: Constants.durationImage, label: durationLabel)
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [originalTitleStack, releaseDateStack, durationStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .init(hex: "#d1453b").withAlphaComponent(0.8)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
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
    
    private lazy var infoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var budgetValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var budgetTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor(hex: "#69696C")
        label.text = Constants.budgetText
        label.textAlignment = .center
        return label
    }()
    
    private lazy var revenueValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var revenueTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor(hex: "#69696C")
        label.text = Constants.revenueText
        label.textAlignment = .center
        return label
    }()
    
    private lazy var voteValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var voteTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor(hex: "#69696C")
        label.text = Constants.voteText
        label.textAlignment = .center
        return label
    }()
    
    private lazy var budgetStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [budgetValueLabel, budgetTitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var revenueStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [revenueValueLabel, revenueTitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var voteStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [voteValueLabel, voteTitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var statsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [budgetStack, revenueStack, voteStack])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Variables
    var presenter: MovieDetailsPresenterProtocol?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.edgesForExtendedLayout = .all
        self.extendedLayoutIncludesOpaqueBars = true
        scrollView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradientView.bounds
        }
    }
    
    private func setup() {
        view.backgroundColor = .black
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(backdropImageView)
        backdropImageView.addSubview(gradientView)
        backdropImageView.addSubview(titleLabel)

        contentView.addSubview(infoContainer)
        infoContainer.addSubview(infoStackView)
        infoContainer.addSubview(favoriteContainerView)
        favoriteContainerView.addSubview(favoriteButton)

        contentView.addSubview(statsStackView)
        contentView.addSubview(overviewLabel)

        setupConstraints()
        setupGradient()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalTo: backdropImageView.widthAnchor, multiplier: Constants.imageRatio),

            gradientView.leadingAnchor.constraint(equalTo: backdropImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: backdropImageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalTo: backdropImageView.heightAnchor, multiplier: 0.3),

            titleLabel.leadingAnchor.constraint(equalTo: backdropImageView.leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: backdropImageView.trailingAnchor, constant: -Constants.padding),
            titleLabel.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -(Constants.padding / 2)),

            infoContainer.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: Constants.padding),
            infoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            infoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),

            infoStackView.topAnchor.constraint(equalTo: infoContainer.topAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor),

            favoriteContainerView.leadingAnchor.constraint(equalTo: infoStackView.trailingAnchor, constant: Constants.padding / 2),
            favoriteContainerView.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor),
            favoriteContainerView.centerYAnchor.constraint(equalTo: infoContainer.centerYAnchor),
            favoriteContainerView.widthAnchor.constraint(equalToConstant: Constants.favoriteContainerSize),
            favoriteContainerView.heightAnchor.constraint(equalToConstant: Constants.favoriteContainerSize),
            
            favoriteButton.centerXAnchor.constraint(equalTo: favoriteContainerView.centerXAnchor),
            favoriteButton.centerYAnchor.constraint(equalTo: favoriteContainerView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: Constants.favoriteSize),
            favoriteButton.heightAnchor.constraint(equalToConstant: Constants.favoriteSize),

            statsStackView.topAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: Constants.padding),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            statsStackView.heightAnchor.constraint(equalToConstant: Constants.statsHeight),

            overviewLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: Constants.padding),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func makeInfoRow(iconName: String, label: UILabel) -> UIStackView {
        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = UIColor(hex: "#99999e")
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: Constants.iconsSize),
            icon.heightAnchor.constraint(equalToConstant: Constants.iconsSize)
        ])
        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    @objc private func favoriteButtonTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.favoriteContainerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.favoriteButton.transform = .identity
                self.favoriteContainerView.transform = .identity
            }, completion: { _ in
                self.presenter?.toggleFavorite()
            })
        })
    }
    
    private func updateFavoriteState(isFavorited: Bool) {
        let imageName = isFavorited ? Constants.favoritedImage : Constants.favoriteImage
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

extension MovieDetailsView: MovieDetailsViewProtocol {
    func showDetails(details: MovieDetailsConfig) {
        DispatchQueue.main.async {            
            self.titleLabel.text = details.title
            self.originalTitleLabel.text = details.originalTitle
            self.releaseDateLabel.text = details.releaseDate
            self.durationLabel.text = details.duration
            
            self.budgetValueLabel.text = details.budget
            self.revenueValueLabel.text = details.revenue
            self.voteValueLabel.text = details.vote
            
            self.overviewLabel.text = details.overview
            self.backdropImageView.loadImage(details.imageURL)
            
            self.updateFavoriteState(isFavorited: details.isFavorited)
        }
    }

    func getCurrentImage() -> UIImage? {
        return self.backdropImageView.image
    }
    
    func updateFavorite(newState: Bool) {
        DispatchQueue.main.async {
            self.updateFavoriteState(isFavorited: newState)
        }
    }

    func showDetailsError(message: String) {
        self.showError(message)
    }
}
