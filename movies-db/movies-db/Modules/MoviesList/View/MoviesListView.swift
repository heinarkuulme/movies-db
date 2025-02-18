//
//  MoviesListView.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

class MoviesListView: BaseViewController {
    
    private enum Constants {
        static let discoverTitle: String = "Descubra"
        static let searchTitle: String = "Resultados"
        static let searchPlaceholder: String = "Pesquisar filmes"
        
        static let barButtonSize: CGFloat = 44.0
        static let barButtonSpacing: CGFloat = 8.0
    }
    
    //MARK: - Outlets
    private lazy var movieGridView: MovieGridView = {
        let gridView = MovieGridView()
        gridView.translatesAutoresizingMaskIntoConstraints = false
        
        return gridView
    }()
    
    //MARK: - Variables
    var presenter: MoviesListPresenterProtocol?
    private var searchController: UISearchController?
    private var searchTimer: Timer?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        setup()
        setupNavigationBar()
        movieGridView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        self.showActivityIndicator()
        presenter?.viewDidAppear()
    }
    
    private func setup() {
        navigationItem.title = Constants.discoverTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        view.addSubview(movieGridView)
        NSLayoutConstraint.activate([
            movieGridView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieGridView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieGridView.topAnchor.constraint(equalTo: view.topAnchor),
            movieGridView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        
        let favoritesButton = UIButton(type: .system)
        favoritesButton.setImage(UIImage(systemName: "heart.circle"), for: .normal)
        favoritesButton.addTarget(self, action: #selector(didTapFavorites), for: .touchUpInside)

        let searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        searchButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [searchButton, favoritesButton])
        stackView.axis = .horizontal
        stackView.spacing = Constants.barButtonSpacing
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        let containerView = UIView()
        containerView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        containerView.frame = CGRect(x: 0, y: 0, width: Constants.barButtonSize * 2, height: Constants.barButtonSize)

        let barButtonItem = UIBarButtonItem(customView: containerView)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc private func didTapSearch() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = Constants.searchPlaceholder
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        DispatchQueue.main.async {
            self.searchController?.searchBar.becomeFirstResponder()
            self.navigationItem.title = Constants.searchTitle
        }
    }
    
    @objc private func didTapFavorites() {
        presenter?.didTapFavorites()
    }

}

extension MoviesListView: MoviesListViewProtocol {
    func showMovies(_ movies: [MovieGridConfig]) {
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            self.movieGridView.setConfig(movies)
        }
    }

    // Simplifiquei a exibição do erro, mas nessa tela poderia ter uma view de error exibindo a mensagem com um botão de tentar novamente
    func showMovieError(message: String) {
        self.hideActivityIndicator()
        self.showError(message)
    }
    
}

extension MoviesListView: MovieGridViewDelegate {
    func movieGridView(_ gridView: MovieGridView, didSelectMovie movie: MovieGridConfig) {
        presenter?.didSelectItem(movie: movie)
    }

    func moviesGridViewDidReachEnd(_ gridView: MovieGridView) {
        presenter?.fetchMoreMovies()
    }

}

extension MoviesListView: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        searchTimer?.invalidate()
        let searchText = searchController.searchBar.text ?? ""
    
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.searchMovies(with: searchText)
        })
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
        navigationItem.title = Constants.discoverTitle
        presenter?.cancelSearch()
    }
}
