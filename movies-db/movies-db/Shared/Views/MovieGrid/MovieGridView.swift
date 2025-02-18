//
//  MovieGridView.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

// Criei um componente de UI, que poderia estar em DS por exemplo, A ideia aqui seria reaproveitar ele em outras telas
// acabei não reaproveitando propositalmente para explorar outras formas de layout (tableview por exemplo na tela de fav)

public struct MovieGridConfig {
    public let id: Int
    public let title: String
    public let releaseDate: String
    public let coverURL: URL?
    public let rating: Float
    public var isFavorited: Bool
    
    public init(id: Int, title: String, releaseDate: String, coverURL: URL? = nil, rating: Float, isFavorited: Bool = false) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.coverURL = coverURL
        self.rating = rating
        self.isFavorited = isFavorited
    }
}

public protocol MovieGridViewDelegate: AnyObject {
    func movieGridView(_ gridView: MovieGridView, didSelectMovie movie: MovieGridConfig)
    func moviesGridViewDidReachEnd(_ gridView: MovieGridView)
}

public class MovieGridView: UIView {
    
    private enum Constants {
        static let horizontalInset: CGFloat = 16
        static let cellSpacing: CGFloat = 12
        static let imageRatio: CGFloat = (750.0 / 500.0)
        static let elementsHeight: CGFloat = 20.0
        static let cellExtraSpacing: CGFloat = 24
        static let totalHorizontalPadding: CGFloat = Constants.horizontalInset * 2 + Constants.cellSpacing
        static let sizeRemainigToFetchMoreItens: CGFloat = 100.0
        
        static let cellIdentifier = "MovieGridCell"
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.horizontalInset, bottom: 0, right: Constants.horizontalInset)
        layout.minimumInteritemSpacing = Constants.cellSpacing
        layout.minimumLineSpacing = Constants.cellSpacing
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(MovieGridCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
        cv.backgroundColor = .clear
        return cv
    }()
    
    public weak var delegate: MovieGridViewDelegate?
    
    private var config: [MovieGridConfig] = []
    private var isFetchingMore: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func setConfig(_ config: [MovieGridConfig]) {
        self.config = config
        isFetchingMore = false
        UIView.performWithoutAnimation {
            self.collectionView.reloadData()
        }
    }
    
}

extension MovieGridView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return config.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? MovieGridCell else {
            return UICollectionViewCell()
        }
        let movie = config[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let config = config[indexPath.item]

        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    cell.transform = .identity
                }, completion: { _ in
                    self.delegate?.movieGridView(self, didSelectMovie: config)
                })
            })
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - Constants.totalHorizontalPadding) / 2
        let imageHeight = width * Constants.imageRatio
        let titleHeight: CGFloat = Constants.elementsHeight
        let releaseDateHeight: CGFloat = Constants.elementsHeight
        let ratingHeight: CGFloat = Constants.elementsHeight
        let spacing: CGFloat = Constants.cellExtraSpacing
        let height = imageHeight + titleHeight + releaseDateHeight + ratingHeight + spacing
        return CGSize(width: width, height: height)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - Constants.sizeRemainigToFetchMoreItens, !isFetchingMore {
            isFetchingMore = true
            delegate?.moviesGridViewDidReachEnd(self)
        }
    }
}
