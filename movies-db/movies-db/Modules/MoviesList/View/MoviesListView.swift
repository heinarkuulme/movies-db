//
//  MoviesListView.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

class MoviesListView: BaseViewController {
    
    //MARK: - Outlets
    private lazy var movieGridView: MovieGridView = {
        let gridView = MovieGridView()
        gridView.translatesAutoresizingMaskIntoConstraints = false
        
        return gridView
    }()
    
    //MARK: - Variables
    var presenter: MoviesListPresenterProtocol?
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        movieGridView.delegate = self
        presenter?.viewDidLoad()
    }
    
    private func setup() {
        navigationItem.title = "Descubra"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(movieGridView)
        NSLayoutConstraint.activate([
            movieGridView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieGridView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieGridView.topAnchor.constraint(equalTo: view.topAnchor),
            movieGridView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

}

extension MoviesListView: MoviesListViewProtocol {
    func updateFavorite(for movie: MovieGridConfig) {
        DispatchQueue.main.async {
            self.movieGridView.updateFavorite(for: movie)
        }
    }

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
        
    }

    func movieGridView(_ gridView: MovieGridView, didToggleFavoriteFor movie: MovieGridConfig) {
        presenter?.didSelectItem(movie: movie)
    }

    func moviesGridViewDidReachEnd(_ gridView: MovieGridView) {
        presenter?.fetchMoreMovies()
    }

    
}
