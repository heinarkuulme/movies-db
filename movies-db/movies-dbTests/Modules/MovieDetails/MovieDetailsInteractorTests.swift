//
//  MovieDetailsInteractorTests.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import XCTest
@testable import movies_db

class MovieDetailsInteractorTests: XCTestCase {
    
    var interactor: MovieDetailsInteractor!
    var fakePresenter: MockMovieDetailsInteractorOutput!
    
    override func setUp() {
        super.setUp()
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.stubError = nil
        interactor = MovieDetailsInteractor()
        fakePresenter = MockMovieDetailsInteractorOutput()
        interactor.presenter = fakePresenter

        URLProtocol.registerClass(MockURLProtocol.self)

        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.favoriteMoviesObjects.rawValue)
    }
    
    override func tearDown() {
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.stubError = nil
        URLProtocol.unregisterClass(MockURLProtocol.self)
        interactor = nil
        fakePresenter = nil
        super.tearDown()
    }
        
    func testFetchMovieDetailsSuccess() {
        let jsonString = """
            {
                "title": "Movie",
                "original_title": "Original title Movie",
                "release_date": "2022-01-01",
                "runtime": 120,
                "budget": 1000000,
                "revenue": 2000000,
                "vote_average": 8.2,
                "overview": "Overview",
                "id": 1,
                "backdrop_path": "/test.jpg",
                "poster_path": ""
            }
        """
        
        let jsonData = jsonString.data(using: .utf8)
        MockURLProtocol.stubResponseData = jsonData

        let expectation = self.expectation(description: "fetchMovieDetails")
        interactor.fetchMovieDetails(id: 1)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    
            XCTAssertNotNil(self.fakePresenter.fetchedDetails, "Must get movie details")
            if let details = self.fakePresenter.fetchedDetails {
                XCTAssertEqual(details.title, "Movie")
                XCTAssertEqual(details.originalTitle, "Original title Movie")
                XCTAssertEqual(details.duration, "120 min")
                XCTAssertNotNil(details.budget)
                XCTAssertNotNil(details.revenue)
                XCTAssertNotNil(details.vote)
                XCTAssertEqual(details.overview, "Overview")
                XCTAssertEqual(details.id, 1)
                let expectedURLString = BaseUrls.images.rawValue + "/test.jpg"
                XCTAssertEqual(details.imageURL?.absoluteString, expectedURLString)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchMovieDetailsFailure() {
        let error = NSError(domain: "Network", code: 400, userInfo: [NSLocalizedDescriptionKey: "Bad Request"])
        MockURLProtocol.stubError = error

        let expectation = self.expectation(description: "fetchMovieDetailsFailure")
        interactor.fetchMovieDetails(id: 1)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.fakePresenter.fetchedError, "Must return an error message")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testCheckFavoriteMovie() {
    
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.favoriteMoviesObjects.rawValue)

        let favoriteMovie = MovieDetailsConfig(
            title: "Fav Movie",
            originalTitle: "",
            releaseDate: "",
            duration: "",
            budget: "",
            revenue: "",
            vote: "",
            overview: "",
            id: 1,
            imageURL: nil,
            image: nil,
            isFavorited: true
        )
        
        UserDefaultsManager.appendFavoriteMovieObject(favoriteMovie)

        interactor.checkFavoriteMovie(id: 1)
        XCTAssertEqual(fakePresenter.favorite, true)

        interactor.checkFavoriteMovie(id: 2)
        XCTAssertEqual(fakePresenter.favorite, false)
    }
    
    func testToggleFavorite() {
    
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.favoriteMoviesObjects.rawValue)

        let movie = MovieDetailsConfig(
            title: "Toggle Movie fav",
            originalTitle: "",
            releaseDate: "",
            duration: "",
            budget: "",
            revenue: "",
            vote: "",
            overview: "",
            id: 10,
            imageURL: nil,
            image: nil,
            isFavorited: false
        )

        interactor.toggleFavorite(movie: movie, newState: true)
        XCTAssertEqual(fakePresenter.favoriteUpdated, true)
        let favoritesAfterAppend = UserDefaultsManager.getFavoriteMoviesObjects()
        XCTAssertTrue(favoritesAfterAppend.contains { $0.id == 10 })

        interactor.toggleFavorite(movie: movie, newState: false)
        XCTAssertEqual(fakePresenter.favoriteUpdated, false)
        let favoritesAfterRemove = UserDefaultsManager.getFavoriteMoviesObjects()
        XCTAssertFalse(favoritesAfterRemove.contains { $0.id == 10 })
    }
}
