//
//  FavoriteMoviesIntegrationTests.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import XCTest
@testable import movies_db

// Fiz um teste mais completo na camada VIPER no modulo de favoritos, como exemplo de implementação.
// Nos outros modulos foquei mais na camada logica

class FavoriteMoviesIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.favoriteMoviesObjects.rawValue)
    }
    
    func testLocalDBIntegrationAppendAndFetch() {
        let movie = MovieDetailsConfig(
            title: "LocalDB Test",
            originalTitle: "",
            releaseDate: "",
            duration: "",
            budget: "",
            revenue: "",
            vote: "",
            overview: "Overview",
            id: 10,
            imageURL: nil,
            image: nil,
            isFavorited: true
        )
        UserDefaultsManager.appendFavoriteMovieObject(movie)

        let favorites = UserDefaultsManager.getFavoriteMoviesObjects()
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.id, movie.id)
    }
    
    func testLocalDBIntegrationRemove() {
        let movie = MovieDetailsConfig(
            title: "LocalDB Remove",
            originalTitle: "",
            releaseDate: "",
            duration: "",
            budget: "",
            revenue: "",
            vote: "",
            overview: "Overview",
            id: 20,
            imageURL: nil,
            image: nil,
            isFavorited: true
        )
        UserDefaultsManager.appendFavoriteMovieObject(movie)

        var favorites = UserDefaultsManager.getFavoriteMoviesObjects()
        XCTAssertEqual(favorites.count, 1)

        UserDefaultsManager.removeFavoriteMovieObject(movie)
        favorites = UserDefaultsManager.getFavoriteMoviesObjects()
        XCTAssertEqual(favorites.count, 0)
    }
    
    func testVIPERModuleInjection() {
        let viewController = FavoriteMoviesRouter.createFavoriteList()

        guard let favoriteMoviesView = viewController as? FavoriteMoviesView else {
            XCTFail("Must be FavoriteMoviesView")
            return
        }

        XCTAssertNotNil(favoriteMoviesView.presenter)
        let presenter = favoriteMoviesView.presenter as? FavoriteMoviesPresenter
        XCTAssertNotNil(presenter?.interactor)
        XCTAssertNotNil(presenter?.router)
        XCTAssertTrue(presenter?.view === favoriteMoviesView)

        if let interactor = presenter?.interactor as? FavoriteMoviesInteractor {
            XCTAssertTrue(interactor.presenter === presenter)
        }
    }
    
}
