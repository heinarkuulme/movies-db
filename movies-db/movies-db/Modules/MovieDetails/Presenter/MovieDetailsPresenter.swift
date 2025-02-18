//
//  MovieDetailsPresenter.swift
//  movies-db
//
//  Created by Heinar Kuulme on 17/02/25.
//

import UIKit

class MovieDetailsPresenter: MovieDetailsPresenterProtocol {

    weak var view: MovieDetailsViewProtocol?
    var interactor: MovieDetailsInteractorInputProtocol?
    var router: MovieDetailsRouterProtocol?
    var movieId: Int = 0
    var details: MovieDetailsConfig?
    
    private var isFavorite: Bool = false
    
    func viewDidLoad() {
        if let movie = details {
            movieId = movie.id ?? 0
            interactor?.checkFavoriteMovie(id: movieId)
            view?.showDetails(details: movie)
        } else {
            interactor?.checkFavoriteMovie(id: movieId)
            interactor?.fetchMovieDetails(id: movieId)
        }
    }
    
    func toggleFavorite() {
        guard var details = self.details else { return }
        let newState = !details.isFavorited
        details.isFavorited = newState
        
        if let currentImage = view?.getCurrentImage() {
            details.image = currentImage
        }
        
        self.details = details
        self.isFavorite = newState

        interactor?.toggleFavorite(movie: details, newState: newState)
    }
}

extension MovieDetailsPresenter: MovieDetailsInteractorOutputProtocol {
    func movieDetailsFetched(details: MovieDetailsConfig) {
        self.details = details
        self.details?.isFavorited = self.isFavorite
        view?.showDetails(details: details)
    }

    func favoriteMovie(isFavorite: Bool) {
        self.isFavorite = isFavorite
    }

    func movieDetailsFetchedFailed(error: String) {
        self.view?.showDetailsError(message: error)
    }

    func favoriteMovieUpdated(newState: Bool) {
        self.details?.isFavorited = newState
        view?.updateFavorite(newState: newState)
    }

    
}
