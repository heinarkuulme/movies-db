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
    func showError()
}

protocol MoviesListPresenterProtocol: AnyObject {
    var view: MoviesListViewProtocol? { get set }
    var interactor: MoviesListInteractorInputProtocol? { get set }
    var router: MoviesListRouterProtocol? { get set }
    func viewDidLoad()
    func didSelectItem(index: Int)
}

protocol MoviesListInteractorInputProtocol: AnyObject {
    var presenter: MoviesListInteractorOutputProtocol? { get set }
    func fetchMovies()
    func getMoviesConfig(_ movies: [Movie])
}

protocol MoviesListInteractorOutputProtocol: AnyObject {
    func moviesFetched(_ moviesList: MoviesList)
    func moviesConfigFacade(_ moviesConfig: [MovieGridConfig])
    func moviesFetchedFailed()
}
