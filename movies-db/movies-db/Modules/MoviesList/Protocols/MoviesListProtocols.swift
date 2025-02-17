//
//  MoviesListProtocols.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

protocol MoviesListRouterProtocol: AnyObject {
    static func createMoviesList() -> UIViewController
}

protocol MoviesListViewProtocol: AnyObject {
    func showMovies(_ movies: [MovieGridConfig])
    func updateFavorite(for movie: MovieGridConfig)
    func showError()
}

protocol MoviesListPresenterProtocol: AnyObject {
    var view: MoviesListViewProtocol? { get set }
    var interactor: MoviesListInteractorInputProtocol? { get set }
    var router: MoviesListRouterProtocol? { get set }
    func viewDidLoad()
    func didSelectItem(movie: MovieGridConfig)
    func fetchMoreMovies()
}

protocol MoviesListInteractorInputProtocol: AnyObject {
    var presenter: MoviesListInteractorOutputProtocol? { get set }
    func fetchMovies(page: Int, favoriteMovies: [Int])
    func fetchFavoriteMovies()
    func toggleFavorite(for movie: MovieGridConfig)
}

protocol MoviesListInteractorOutputProtocol: AnyObject {
    func moviesFetched(_ moviesConfig: [MovieGridConfig], page: Int, totalPages: Int)
    func favoriteMoviesFetched(ids: [Int])
    func moviesFetchedFailed()
    func favoriteMovieUpdated(ids: [Int], for movieID: Int, newState: Bool)
}
