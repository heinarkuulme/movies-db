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
    
    func viewDidAppear() {
        interactor?.fetchMovies(page: currentPage)
    }

    func didSelectItem(movie: MovieGridConfig) {
        if let viewController = view as? UIViewController {
            router?.navigateToMovieDetails(from: viewController, with: movie.id)
        }
    }
    
    func fetchMoreMovies() {
        if currentPage < totalPages {
            let nextPage = currentPage + 1
            interactor?.fetchMovies(page: nextPage)
        }
    }
    
    func searchMovies(with query: String) {
        currentPage = 1
        totalPages = 1
        interactor?.searchMovies(query: query, page: currentPage)
    }

    func cancelSearch() {
        currentPage = 1
        totalPages = 1
        interactor?.fetchMovies(page: currentPage)
    }
}

extension MoviesListPresenter: MoviesListInteractorOutputProtocol {
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
    
    func moviesFetchedFailed() {
        print("view -> show error")
    }
}
