//
//  MovieDetailsProtocols.swift
//  movies-db
//
//  Created by Heinar Kuulme on 17/02/25.
//

import UIKit

protocol MovieDetailsRouterProtocol: AnyObject {
    static func createMovieDetails(id: Int) -> UIViewController
}

protocol MovieDetailsViewProtocol: AnyObject {
    func showDetails(details: MovieDetailsConfig)
    func updateFavorite(newState: Bool)
    func showError()
}

protocol MovieDetailsPresenterProtocol: AnyObject {
    var view: MovieDetailsViewProtocol? { get set }
    var interactor: MovieDetailsInteractorInputProtocol? { get set }
    var router: MovieDetailsRouterProtocol? { get set }
    var movieId: Int { get set }
    func viewDidLoad()
    func toggleFavorite()
}

protocol MovieDetailsInteractorInputProtocol: AnyObject {
    var presenter: MovieDetailsInteractorOutputProtocol? { get set }
    func fetchMovieDetails(id: Int)
    func checkFavoriteMovie(id: Int)
    func toggleFavorite(movie: MovieDetailsConfig, newState: Bool)
}

protocol MovieDetailsInteractorOutputProtocol: AnyObject {
    func movieDetailsFetched(details: MovieDetailsConfig)
    func favoriteMovie(isFavorite: Bool)
    func movieDetailsFetchedFailed()
    func favoriteMovieUpdated(newState: Bool)
}

