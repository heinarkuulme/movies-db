//
//  MoviesListRouter.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

class MoviesListRouter: MoviesListRouterProtocol {
    
    // Criação do module com as injeções de dependências
    static func createMoviesList() -> UIViewController {
        let view = MoviesListView()
        let presenter: MoviesListPresenterProtocol & MoviesListInteractorOutputProtocol = MoviesListPresenter()
        let interactor: MoviesListInteractorInputProtocol = MoviesListInteractor()
        let router: MoviesListRouterProtocol = MoviesListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }

}
