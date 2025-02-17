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
    private var moviesList: MoviesList?
    private var moviesConfig: [MovieGridConfig] = []
    
    func viewDidLoad() {
        interactor?.fetchMovies()
    }

    func didSelectItem(index: Int) {
        
    }
    
}

extension MoviesListPresenter: MoviesListInteractorOutputProtocol {
    
    func moviesConfigFacade(_ moviesConfig: [MovieGridConfig]) {
        self.moviesConfig = moviesConfig
        view?.showMovies(moviesConfig)
    }

    func moviesFetched(_ moviesList: MoviesList) {
        self.moviesList = moviesList
        if let movies = self.moviesList?.results {
            interactor?.getMoviesConfig(movies)
        }
    }

    func moviesFetchedFailed() {
        print("view -> show error")
    }
}
