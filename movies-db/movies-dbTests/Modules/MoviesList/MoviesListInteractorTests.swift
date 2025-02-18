//
//  MoviesListInteractorTests.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import XCTest
@testable import movies_db

class MoviesListInteractorTests: XCTestCase {
    var interactor: MoviesListInteractor!
    var fakePresenter: MockMoviesListInteractorOutput!
    
    override func setUp() {
        super.setUp()
    
        URLProtocol.registerClass(MockURLProtocol.self)
        interactor = MoviesListInteractor()
        fakePresenter = MockMoviesListInteractorOutput()
        interactor.presenter = fakePresenter

        MockURLProtocol.stubError = nil
        MockURLProtocol.stubResponseData = nil
    }
    
    override func tearDown() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        interactor = nil
        fakePresenter = nil
        super.tearDown()
    }
    
    func testFetchMoviesSuccess() {
        let jsonString = """
        {
            "page": 1,
            "results": [
                {
                    "id": 123,
                    "release_date": "2022-01-01",
                    "title": "Test Movie",
                    "vote_average": 8.5,
                    "poster_path": "/test.jpg"
                }
            ],
            "total_pages": 1,
            "total_results": 1
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)
        MockURLProtocol.stubResponseData = jsonData

        let expectation = self.expectation(description: "fetchMovies")
        interactor.fetchMovies(page: 1)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.fakePresenter.moviesConfig, "Must return movies list")
            XCTAssertEqual(self.fakePresenter.moviesConfig?.count, 1)
            XCTAssertEqual(self.fakePresenter.page, 1)
            XCTAssertEqual(self.fakePresenter.totalPages, 1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchMoviesFailure() {
        let error = NSError(domain: "Network", code: 400, userInfo: [NSLocalizedDescriptionKey: "Bad Request"])
        MockURLProtocol.stubError = error

        let expectation = self.expectation(description: "fetchMoviesFailure")
        interactor.fetchMovies(page: 1)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.fakePresenter.errorMessage)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testSearchMoviesSuccess() {
        let jsonString = """
            {
                "page": 2,
                "results": [
                    {
                        "id": 456,
                        "release_date": "2021-12-31",
                        "title": "Searched Movie",
                        "vote_average": 7.0,
                        "poster_path": "/search.jpg"
                    }
                ],
                "total_pages": 3,
                "total_results": 10
            }
        """
        let jsonData = jsonString.data(using: .utf8)
        MockURLProtocol.stubResponseData = jsonData

        let expectation = self.expectation(description: "searchMovies")
        interactor.searchMovies(query: "Test", page: 2)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.fakePresenter.moviesConfig)
            XCTAssertEqual(self.fakePresenter.moviesConfig?.first?.id, 456)
            XCTAssertEqual(self.fakePresenter.page, 2)
            XCTAssertEqual(self.fakePresenter.totalPages, 3)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testRefreshFavoritesUpdatesMovies() {
    
        let favoriteMovie = MovieDetailsConfig(
            title: "Favorited",
            originalTitle: "",
            releaseDate: "",
            duration: "",
            budget: "",
            revenue: "",
            vote: "",
            overview: "",
            id: 999,
            imageURL: nil,
            image: nil,
            isFavorited: true
        )
        
        UserDefaultsManager.appendFavoriteMovieObject(favoriteMovie)

        let movieConfig = MovieGridConfig(
            id: 999,
            title: "Movie",
            releaseDate: "2022-05-05",
            coverURL: URL(string: "https://example.com/cover.jpg"),
            rating: 8.0,
            isFavorited: false
        )

        interactor.refreshFavorites(movies: [movieConfig])

        XCTAssertNotNil(fakePresenter.updatedMoviesConfig)
        let updatedMovie = fakePresenter.updatedMoviesConfig?.first
        XCTAssertTrue(updatedMovie?.isFavorited ?? false)
    }
    
}
