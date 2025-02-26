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

    
    func navigateToMovieDetails(from view: UIViewController, with movieId: Int) {
        let detailsVC = MovieDetailsRouter.createMovieDetails(id: movieId)
        if let navController = view.navigationController {
            navController.pushViewController(detailsVC, animated: true)
        } else {
            view.present(detailsVC, animated: true, completion: nil)
        }
    }
    
    func navigateToFavorites(from view: UIViewController) {
        let favoritesVC = FavoriteMoviesRouter.createFavoriteList()
        if let navController = view.navigationController {
            navController.pushViewController(favoritesVC, animated: true)
        } else {
            view.present(favoritesVC, animated: true, completion: nil)
        }
    }
}
