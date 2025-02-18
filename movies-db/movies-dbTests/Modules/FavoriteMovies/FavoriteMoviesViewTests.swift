//
//  FavoriteMoviesViewTests.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import XCTest
@testable import movies_db

class FavoriteMoviesViewTests: XCTestCase {
    var favoriteMoviesView: FavoriteMoviesView!

    override func setUp() {
        super.setUp()
        favoriteMoviesView = FavoriteMoviesView()
        _ = favoriteMoviesView.view
    }
    
    func testShowFavoritesReloadsTableView() {
        let movie1 = MovieDetailsConfig(title: "Movie 1",
                                        originalTitle: "Original title 1",
                                        releaseDate: "01-01-2022",
                                        duration: "100 min",
                                        budget: "$100.000.000",
                                        revenue: "$200.000.000",
                                        vote: "8.0",
                                        overview: "Overview 1",
                                        id: 1,
                                        imageURL: nil,
                                        image: nil,
                                        isFavorited: true)

        let movie2 = MovieDetailsConfig(title: "Movie 2",
                                        originalTitle: "Original title 2",
                                        releaseDate: "01-01-2022",
                                        duration: "110 min",
                                        budget: "$100.000.000",
                                        revenue: "$200.000.000",
                                        vote: "7.5",
                                        overview: "Overview 2",
                                        id: 2,
                                        imageURL: nil,
                                        image: nil,
                                        isFavorited: false)

        let movies = [movie1, movie2]

        favoriteMoviesView.showFavorites(movies: movies)

        let tableView = favoriteMoviesView.view.findTableView()
        XCTAssertNotNil(tableView, "A tableView must exists")
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), movies.count, "Same rows as movies")
    }

}

extension UIView {
    func findTableView() -> UITableView? {
        if let tableView = self as? UITableView {
            return tableView
        }
        for subview in subviews {
            if let found = subview.findTableView() {
                return found
            }
        }
        return nil
    }
}
