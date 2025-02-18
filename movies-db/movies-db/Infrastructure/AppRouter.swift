//
//  AppRouter.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

// classe para definir as rotas do app, poderia ter uma condição de usuário logado ou não e mandar para uma tela de login por exemplo
class AppRouter {
    
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let moviesListModule = MoviesListRouter.createMoviesList()
        let navigation = BaseNavigationController(rootViewController: moviesListModule)
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
    }
}
