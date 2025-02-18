//
//  MovieDetailsConfigTests.swift
//  movies-db
//
//  Created by Heinar Kuulme on 18/02/25.
//

import XCTest
@testable import movies_db

class MovieDetailsConfigTests: XCTestCase {
    
    func testEntityToDictionaryAndBack() {
        let url = URL(string: "https://example.com/image.jpg")
        let movie = MovieDetailsConfig(title: "Title Movie",
                                       originalTitle: "Original title Movie",
                                       releaseDate: "01-01-2022",
                                       duration: "120 min",
                                       budget: "$100.000.000",
                                       revenue: "$100.000.000",
                                       vote: "9.0",
                                       overview: "Overview",
                                       id: 1,
                                       imageURL: url,
                                       image: nil,
                                       isFavorited: true)

        let dict = movie.toDictionary()
        let newMovie = MovieDetailsConfig(dictionary: dict)

        XCTAssertNotNil(newMovie, "Must not be nil")
        XCTAssertEqual(newMovie?.title, movie.title)
        XCTAssertEqual(newMovie?.originalTitle, movie.originalTitle)
        XCTAssertEqual(newMovie?.releaseDate, movie.releaseDate)
        XCTAssertEqual(newMovie?.duration, movie.duration)
        XCTAssertEqual(newMovie?.budget, movie.budget)
        XCTAssertEqual(newMovie?.revenue, movie.revenue)
        XCTAssertEqual(newMovie?.vote, movie.vote)
        XCTAssertEqual(newMovie?.overview, movie.overview)
        XCTAssertEqual(newMovie?.id, movie.id)
        XCTAssertEqual(newMovie?.isFavorited, movie.isFavorited)

        if let newURL = newMovie?.imageURL, let originalURL = movie.imageURL {
            XCTAssertEqual(newURL.absoluteString, originalURL.absoluteString)
        }
    }
    
}
