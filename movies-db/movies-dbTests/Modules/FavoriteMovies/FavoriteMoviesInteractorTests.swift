//
//  FavoriteMoviesInteractorTests.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import XCTest
@testable import movies_db

class FavoriteMoviesInteractorTests: XCTestCase {
    var interactor: FavoriteMoviesInteractor!
    var fakePresenter: MockFavoriteMoviesInteractorOutput!
    
    override func setUp() {
        super.setUp()
    
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.favoriteMoviesObjects.rawValue)
        interactor = FavoriteMoviesInteractor()
        fakePresenter = MockFavoriteMoviesInteractorOutput()
        interactor.presenter = fakePresenter
    }
    
    func testFetchFavoritesReturnsEmptyWhenNoFavorites() {
        interactor.fetchFavorites()
        XCTAssertNotNil(fakePresenter.favoritesFetchedMovies)
        XCTAssertEqual(fakePresenter.favoritesFetchedMovies?.count, 0)
    }
    
    func testRemoveFromFavoriteRemovesMovie() {
        let movie = MovieDetailsConfig(
            title: "Test Interactor",
            originalTitle: "",
            releaseDate: "",
            duration: "",
            budget: "",
            revenue: "",
            vote: "",
            overview: "Overview",
            id: 1,
            imageURL: nil,
            image: nil,
            isFavorited: true
        )
        
        UserDefaultsManager.appendFavoriteMovieObject(movie)

        var favorites = UserDefaultsManager.getFavoriteMoviesObjects()
        XCTAssertEqual(favorites.count, 1)

        interactor.removeFromFavorite(movie: movie)
        favorites = UserDefaultsManager.getFavoriteMoviesObjects()
        XCTAssertEqual(favorites.count, 0)

        XCTAssertNotNil(fakePresenter.favoritesFetchedMovies)
        XCTAssertEqual(fakePresenter.favoritesFetchedMovies?.count, 0)
    }
}
