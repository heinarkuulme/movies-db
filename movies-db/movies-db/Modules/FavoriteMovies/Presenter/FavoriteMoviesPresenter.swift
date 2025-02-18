//
//  FavoriteMoviesPresenter.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import UIKit

class FavoriteMoviesPresenter: FavoriteMoviesPresenterProtocol {

    weak var view: FavoriteMoviesViewProtocol?
    var interactor: FavoriteMoviesInteractorInputProtocol?
    var router: FavoriteMoviesRouterProtocol?
    var favorites: [MovieDetailsConfig] = []

    private var details: MovieDetailsConfig?
    private var isFavorite: Bool = false
    
    func viewDidAppear() {
        interactor?.fetchFavorites()
    }
    
    func didTapRemoveFavorite(index: Int) {
        if favorites.indices.contains(index) {
            interactor?.removeFromFavorite(movie: favorites[index])
        }
    }
}

extension FavoriteMoviesPresenter: FavoriteMoviesInteractorOutputProtocol {
    func favoritesFetched(movies: [MovieDetailsConfig]) {
        self.favorites = movies
        view?.showFavorites(movies: self.favorites)
    }

    func favoriteFetchedFailed(error: String) {
        view?.showFavoriteError(message: error)
    }

}

