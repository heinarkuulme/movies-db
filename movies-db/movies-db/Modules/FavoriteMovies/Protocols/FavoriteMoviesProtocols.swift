//
//  FavoriteMoviesProtocols.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import UIKit

protocol FavoriteMoviesRouterProtocol: AnyObject {
    static func createFavoriteList() -> UIViewController
}

protocol FavoriteMoviesViewProtocol: AnyObject {
    func showFavorites(movies: [MovieDetailsConfig])
    func showFavoriteError(message: String)
}

protocol FavoriteMoviesPresenterProtocol: AnyObject {
    var view: FavoriteMoviesViewProtocol? { get set }
    var interactor: FavoriteMoviesInteractorInputProtocol? { get set }
    var router: FavoriteMoviesRouterProtocol? { get set }
    func viewDidAppear()
    func didTapRemoveFavorite(index: Int)
}

protocol FavoriteMoviesInteractorInputProtocol: AnyObject {
    var presenter: FavoriteMoviesInteractorOutputProtocol? { get set }
    func fetchFavorites()
    func removeFromFavorite(movie: MovieDetailsConfig)
}

protocol FavoriteMoviesInteractorOutputProtocol: AnyObject {
    func favoritesFetched(movies: [MovieDetailsConfig])
    func favoriteFetchedFailed(error: String)
}

