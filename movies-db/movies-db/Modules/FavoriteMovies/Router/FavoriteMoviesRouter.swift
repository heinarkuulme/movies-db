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
    
    func navigateToMovieDetails(from view: UIViewController, with movieConfig: MovieDetailsConfig) {
        let detailsVC = MovieDetailsRouter.createMovieDetails(with: movieConfig)
        if let navController = view.navigationController {
            navController.pushViewController(detailsVC, animated: true)
        } else {
            view.present(detailsVC, animated: true, completion: nil)
        }
    }

}
