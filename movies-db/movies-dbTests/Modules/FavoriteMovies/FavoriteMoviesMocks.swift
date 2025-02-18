//
//  FavoriteMoviesMocks.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import XCTest
@testable import movies_db

class MockFavoriteMoviesView: UIViewController, FavoriteMoviesViewProtocol {
    var favoritesShown: [MovieDetailsConfig]?
    var errorMessage: String?

    func showFavorites(movies: [MovieDetailsConfig]) {
        favoritesShown = movies
    }

    func showFavoriteError(message: String) {
        errorMessage = message
    }
}

class MockFavoriteMoviesInteractor: FavoriteMoviesInteractorInputProtocol {
    var presenter: FavoriteMoviesInteractorOutputProtocol?
    var fetchFavoritesCalled = false
    var removeFromFavoriteCalled = false
    var removedMovie: MovieDetailsConfig?

    func fetchFavorites() {
        fetchFavoritesCalled = true
    }

    func removeFromFavorite(movie: MovieDetailsConfig) {
        removeFromFavoriteCalled = true
        removedMovie = movie
    }
}

class MockFavoriteMoviesRouter: FavoriteMoviesRouterProtocol {
    var navigateToMovieDetailsCalled: ((UIViewController, MovieDetailsConfig) -> Void)?

    static func createFavoriteList() -> UIViewController {
        return UIViewController()
    }

    func navigateToMovieDetails(from view: UIViewController, with movieConfig: MovieDetailsConfig) {
        navigateToMovieDetailsCalled?(view, movieConfig)
    }
}

class MockFavoriteMoviesInteractorOutput: FavoriteMoviesInteractorOutputProtocol {
    var favoritesFetchedMovies: [MovieDetailsConfig]?
    var error: String?

    func favoritesFetched(movies: [MovieDetailsConfig]) {
        favoritesFetchedMovies = movies
    }

    func favoriteFetchedFailed(error: String) {
        self.error = error
    }
}

class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}
