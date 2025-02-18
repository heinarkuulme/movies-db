//
//  FavoriteMoviesPresenterTests.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import XCTest
@testable import movies_db

class FavoriteMoviesPresenterTests: XCTestCase {
    var presenter: FavoriteMoviesPresenter!
    var fakeView: MockFavoriteMoviesView!
    var fakeInteractor: MockFavoriteMoviesInteractor!
    var fakeRouter: MockFavoriteMoviesRouter!

    override func setUp() {
        super.setUp()
        presenter = FavoriteMoviesPresenter()
        fakeView = MockFavoriteMoviesView()
        fakeInteractor = MockFavoriteMoviesInteractor()
        fakeRouter = MockFavoriteMoviesRouter()

        presenter.view = fakeView
        presenter.interactor = fakeInteractor
        presenter.router = fakeRouter
    }
    
    func testViewDidAppearCallsFetchFavorites() {
        presenter.viewDidAppear()
        XCTAssertTrue(fakeInteractor.fetchFavoritesCalled, "viewDidAppear() calls interactor.fetchFavorites()")
    }
    
    func testFavoritesFetchedUpdatesView() {
        let movie = MovieDetailsConfig(title: "Movie",
                                       originalTitle: nil,
                                       releaseDate: nil,
                                       duration: nil,
                                       budget: nil,
                                       revenue: nil,
                                       vote: nil,
                                       overview: "Overview",
                                       id: 1, imageURL: nil,
                                       image: nil,
                                       isFavorited: true
        )
        let movies = [movie]
        presenter.favoritesFetched(movies: movies)

        XCTAssertNotNil(fakeView.favoritesShown)
        XCTAssertEqual(fakeView.favoritesShown?.count, 1)
        XCTAssertEqual(fakeView.favoritesShown?.first?.title, "Movie")
    }
    
    func testDidTapRemoveFavoriteCallsInteractor() {
        
        let movie = MovieDetailsConfig(
            title: "Movie",
            originalTitle: nil,
            releaseDate: nil,
            duration: nil,
            budget: nil,
            revenue: nil,
            vote: nil,
            overview: "Overview",
            id: 1,
            imageURL: nil,
            image: nil,
            isFavorited: true
        )
        presenter.favorites = [movie]

        presenter.didTapRemoveFavorite(index: 0)
        XCTAssertTrue(fakeInteractor.removeFromFavoriteCalled, "didTapRemoveFavorite(), interactor.removeFromFavorite() must be called")
        XCTAssertEqual(fakeInteractor.removedMovie?.id, movie.id)
    }
    
    func testDidSelectItemCallsRouter() {
        let movie = MovieDetailsConfig(
            title: "Movie",
            originalTitle: nil,
            releaseDate: nil,
            duration: nil,
            budget: nil,
            revenue: nil,
            vote: nil,
            overview: "Overview",
            id: 1,
            imageURL: nil,
            image: nil,
            isFavorited: true
        )
        let expectation = self.expectation(description: "Router called")

        fakeRouter.navigateToMovieDetailsCalled = { view, movieConfig in
            XCTAssertEqual(movieConfig.id, movie.id)
            expectation.fulfill()
        }

        fakeView.title = "Fake"
        presenter.view = fakeView
        presenter.didSelectItem(movie: movie)

        waitForExpectations(timeout: 1, handler: nil)
    }

}
