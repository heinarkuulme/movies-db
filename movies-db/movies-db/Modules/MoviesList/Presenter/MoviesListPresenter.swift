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
    
    func viewDidLoad() {
        interactor?.fetchMovies()
    }

    func didSelectItem(index: Int) {
        
    }
    
}

extension MoviesListPresenter: MoviesListInteractorOutputProtocol {
    func moviesFetched(_ moviesList: MoviesList) {
        self.moviesList = moviesList
        print("view -> show movies")
    }

    func moviesFetchedFailed() {
        print("view -> show error")
    }
}
