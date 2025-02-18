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
    
    func viewDidAppear() {
        interactor?.fetchFavorites()
    }
    
    func didTapRemoveFavorite(index: Int) {
        if favorites.indices.contains(index) {
            interactor?.removeFromFavorite(movie: favorites[index])
        }
    }
    
    func didSelectItem(movie: MovieDetailsConfig) {
        if let viewController = view as? UIViewController {
            router?.navigateToMovieDetails(from: viewController, with: movie)
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

