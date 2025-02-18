//
//  MoviesListMocks.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import XCTest
@testable import movies_db

class MockMoviesListInteractorOutput: MoviesListInteractorOutputProtocol {
    var moviesConfig: [MovieGridConfig]?
    var page: Int?
    var totalPages: Int?
    var errorMessage: String?
    var updatedMoviesConfig: [MovieGridConfig]?

    func moviesFetched(_ moviesConfig: [MovieGridConfig], page: Int, totalPages: Int) {
        self.moviesConfig = moviesConfig
        self.page = page
        self.totalPages = totalPages
    }

    func moviesFetchedFailed(error: String) {
        self.errorMessage = error
    }

    func updatedFavoritesFetched(_ moviesConfig: [MovieGridConfig]) {
        self.updatedMoviesConfig = moviesConfig
    }
}
