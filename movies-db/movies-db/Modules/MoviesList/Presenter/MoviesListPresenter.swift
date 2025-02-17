//
//  MoviesListPresenter.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

class MoviesListPresenter: MoviesListPresenterProtocol {

    //Referência fraca da view para evitar retain cycle
    weak var view: MoviesListViewProtocol?
    var interactor: MoviesListInteractorInputProtocol?
    var router: MoviesListRouterProtocol?
    
    private var moviesConfig: [MovieGridConfig] = []
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var favoriteMovies: [Int] = []
    
    func viewDidLoad() {
        interactor?.fetchFavoriteMovies()
        interactor?.fetchMovies(page: currentPage, favoriteMovies: favoriteMovies)
    }

    func didSelectItem(movie: MovieGridConfig) {
        interactor?.toggleFavorite(for: movie)
    }
    
    func fetchMoreMovies() {
        if currentPage < totalPages {
            let nextPage = currentPage + 1
            interactor?.fetchMovies(page: nextPage, favoriteMovies: favoriteMovies)
        }
    }
}

extension MoviesListPresenter: MoviesListInteractorOutputProtocol {
    func favoriteMoviesFetched(ids: [Int]) {
        if self.favoriteMovies.isEmpty {
            favoriteMovies = ids
        } else {
            favoriteMovies.append(contentsOf: ids)
        }
    }

    func moviesFetched(_ moviesConfig: [MovieGridConfig], page: Int, totalPages: Int) {
        if page == 1 {
            self.moviesConfig = moviesConfig
        } else {
            self.moviesConfig.append(contentsOf: moviesConfig)
        }
        
        self.currentPage = page
        self.totalPages = totalPages
        view?.showMovies(self.moviesConfig)
    }
    
    func favoriteMovieUpdated(ids: [Int], for movieID: Int, newState: Bool) {
        if let index = moviesConfig.firstIndex(where: { $0.id == movieID }) {
            moviesConfig[index].isFavorited = newState
            favoriteMovies = ids
            let updatedMovie = moviesConfig[index]
            view?.updateFavorite(for: updatedMovie)
        }
    }

    func moviesFetchedFailed() {
        print("view -> show error")
    }
}
