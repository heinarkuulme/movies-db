//
//  AppRouter.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

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
