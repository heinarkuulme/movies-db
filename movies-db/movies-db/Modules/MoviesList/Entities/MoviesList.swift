//
//  MoviesList.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

// MARK: - Movies list

class MoviesListResponse: NetworkResponse<MoviesList> {}

struct MoviesList: Codable {
    let page: Int?
    let results: [Movie]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

protocol MovieProtocol {
    var id: Int? { get }
    var releaseDate: String? { get }
    var title: String? { get }
    var voteAverage: Double? { get }
    var posterPath: String? { get }
}

struct Movie: MovieProtocol, Codable {
    let id: Int?
    let releaseDate: String?
    let title: String?
    let voteAverage: Double?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
}
