//
//  FavoriteMoviesRouterTests.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import XCTest
@testable import movies_db

class FavoriteMoviesRouterTests: XCTestCase {
    
    func testNavigateToMovieDetailsPushesViewController() {
        let router = FavoriteMoviesRouter()
        let movie = MovieDetailsConfig(title: "Movie",
                                       originalTitle: nil,
                                       releaseDate: nil,
                                       duration: nil,
                                       budget: nil,
                                       revenue: nil,
                                       vote: nil,
                                       overview: "Overview",
                                       id: 123,
                                       imageURL: nil,
                                       image: nil,
                                       isFavorited: true
        )

        let rootVC = UIViewController()
        let fakeNav = MockNavigationController(rootViewController: rootVC)

        router.navigateToMovieDetails(from: rootVC, with: movie)

        XCTAssertNotNil(fakeNav.pushedViewController, "Must push viewController")
    }
}
