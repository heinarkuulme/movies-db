//
//  FavoriteMoviesInteractor.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import UIKit

class FavoriteMoviesInteractor: FavoriteMoviesInteractorInputProtocol {
    
    weak var presenter: FavoriteMoviesInteractorOutputProtocol?
    
    func fetchFavorites() {
        let favorites = UserDefaultsManager.getFavoriteMoviesObjects()
        presenter?.favoritesFetched(movies: favorites)
    }

    func removeFromFavorite(movie: MovieDetailsConfig) {
        UserDefaultsManager.removeFavoriteMovieObject(movie)
        let favorites = UserDefaultsManager.getFavoriteMoviesObjects()
        presenter?.favoritesFetched(movies: favorites)
    }

}

