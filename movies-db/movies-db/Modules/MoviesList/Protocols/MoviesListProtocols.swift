//
//  MoviesListProtocols.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

protocol MoviesListRouterProtocol: AnyObject {
    static func createMoviesList() -> UIViewController
    func navigateToMovieDetails(from view: UIViewController, with movieId: Int)
}

protocol MoviesListViewProtocol: AnyObject {
    func showMovies(_ movies: [MovieGridConfig])
    func showError()
}

protocol MoviesListPresenterProtocol: AnyObject {
    var view: MoviesListViewProtocol? { get set }
    var interactor: MoviesListInteractorInputProtocol? { get set }
    var router: MoviesListRouterProtocol? { get set }
    func viewDidAppear()
    func didSelectItem(movie: MovieGridConfig)
    func fetchMoreMovies()
    func searchMovies(with query: String)
    func cancelSearch()
}

protocol MoviesListInteractorInputProtocol: AnyObject {
    var presenter: MoviesListInteractorOutputProtocol? { get set }
    func fetchMovies(page: Int)
    func searchMovies(query: String, page: Int)
}

protocol MoviesListInteractorOutputProtocol: AnyObject {
    func moviesFetched(_ moviesConfig: [MovieGridConfig], page: Int, totalPages: Int)
    func moviesFetchedFailed()
}
