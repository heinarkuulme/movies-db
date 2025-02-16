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
    func showMovies()
    func showError()
}

protocol MoviesListPresenterProtocol: AnyObject {
    var view: MoviesListViewProtocol? { get set }
    var interactor: MoviesListInteractorInputProtocol? { get set }
    var router: MoviesListRouterProtocol? { get set }
    func viewDidLoad()
    func didSelectItem()
}

protocol MoviesListInteractorInputProtocol: AnyObject {
    var presenter: MoviesListInteractorOutputProtocol? { get set }
    func fetchMovies()
}

protocol MoviesListInteractorOutputProtocol: AnyObject {
    func moviesFetched()
    func moviesFetchedFailed()
}
