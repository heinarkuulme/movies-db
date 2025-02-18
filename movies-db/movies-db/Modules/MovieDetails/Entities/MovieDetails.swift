//
//  MovieDetails.swift
//  movies-db
//
//  Created by Heinar Kuulme on 17/02/25.
//

class MoviesDetailsResponse: NetworkResponse<MovieDetails> {}

struct MovieDetails: MovieProtocol, Codable {
    let id: Int?
    let releaseDate: String?
    let title: String?
    let voteAverage: Double?
    let posterPath: String?

    let backdropPath: String?
    let originalTitle, overview: String?
    let budget: Int
    let revenue: Int
    let runtime: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case originalTitle = "original_title"
        case overview
        case budget, revenue, runtime
    }
}
