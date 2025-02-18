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
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass.circle"), style: .plain, target: self, action: #selector(didTapSearch))
        navigationItem.rightBarButtonItem = searchButton
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

}

extension MoviesListView: MoviesListViewProtocol {
    func showMovies(_ movies: [MovieGridConfig]) {
        DispatchQueue.main.async {
            self.movieGridView.setConfig(movies)
        }
    }

    func showError() {
        
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
