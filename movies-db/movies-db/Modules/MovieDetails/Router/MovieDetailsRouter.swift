//
//  MovieDetailsRouter.swift
//  movies-db
//
//  Created by Heinar Kuulme on 17/02/25.
//

import UIKit

class MovieDetailsRouter: MovieDetailsRouterProtocol {
    
    static func createMovieDetails(id: Int) -> UIViewController {
        let view = MovieDetailsView()
        let presenter: MovieDetailsPresenter & MovieDetailsInteractorOutputProtocol = MovieDetailsPresenter()
        let interactor: MovieDetailsInteractorInputProtocol = MovieDetailsInteractor()
        let router: MovieDetailsRouterProtocol = MovieDetailsRouter()
        
        presenter.movieId = id
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    static func createMovieDetails(with movie: MovieDetailsConfig) -> UIViewController {
        let view = MovieDetailsView()
        let presenter: MovieDetailsPresenter & MovieDetailsInteractorOutputProtocol = MovieDetailsPresenter()
        let interactor: MovieDetailsInteractorInputProtocol = MovieDetailsInteractor()
        let router: MovieDetailsRouterProtocol = MovieDetailsRouter()
        
        presenter.details = movie
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }

}
