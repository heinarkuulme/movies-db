//
//  FavoriteMoviesRouter.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import UIKit

class FavoriteMoviesRouter: FavoriteMoviesRouterProtocol {
    
    static func createFavoriteList() -> UIViewController {
        let view = FavoriteMoviesView()
        let presenter: FavoriteMoviesPresenter & FavoriteMoviesInteractorOutputProtocol = FavoriteMoviesPresenter()
        let interactor: FavoriteMoviesInteractorInputProtocol = FavoriteMoviesInteractor()
        let router: FavoriteMoviesRouterProtocol = FavoriteMoviesRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }

}
