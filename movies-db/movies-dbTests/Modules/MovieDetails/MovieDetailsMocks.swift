//
//  MovieDetailsMocks.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import XCTest
@testable import movies_db

class MockMovieDetailsInteractorOutput: MovieDetailsInteractorOutputProtocol {
    var fetchedDetails: MovieDetailsConfig?
    var fetchedError: String?
    var favorite: Bool?
    var favoriteUpdated: Bool?

    func movieDetailsFetched(details: MovieDetailsConfig) {
        fetchedDetails = details
    }

    func favoriteMovie(isFavorite: Bool) {
        favorite = isFavorite
    }

    func movieDetailsFetchedFailed(error: String) {
        fetchedError = error
    }

    func favoriteMovieUpdated(newState: Bool) {
        favoriteUpdated = newState
    }
}
