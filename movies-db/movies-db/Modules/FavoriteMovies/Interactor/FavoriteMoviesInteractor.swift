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
        guard let movieID = movie.id else { return }

        var favoriteIds = UserDefaultsManager.getFavoritedMovies()
        favoriteIds.removeAll(where: { $0 == movieID })
        UserDefaultsManager.removeFavoriteMovieObject(movie)
        UserDefaultsManager.favoriteMovies.setObject(object: favoriteIds)
        
        let favorites = UserDefaultsManager.getFavoriteMoviesObjects()
        presenter?.favoritesFetched(movies: favorites)
    }

}

