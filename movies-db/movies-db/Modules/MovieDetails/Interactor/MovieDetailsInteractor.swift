//
//  MovieDetailsInteractor.swift
//  movies-db
//
//  Created by Heinar Kuulme on 17/02/25.
//

import UIKit

class MovieDetailsInteractor: MovieDetailsInteractorInputProtocol {
    
    weak var presenter: MovieDetailsInteractorOutputProtocol?

    func fetchMovieDetails(id: Int) {
        MoviesService.Endpoints.details(id: id)
            .makeRequest(printResponse: true) { [weak self] (result: Result<MoviesDetailsResponse, NetworkError>) in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let moviesResponse):
                    if let details = moviesResponse.response {
                        let config = self.getMovieDetailsConfig(details)
                        self.presenter?.movieDetailsFetched(details: config)
                    }
                case .failure(let error):
                    self.presenter?.movieDetailsFetchedFailed(error: error.message)
                }
            }
    }

    func checkFavoriteMovie(id: Int) {
        let favoriteMovies = UserDefaultsManager.getFavoriteMoviesObjects()
        let favoriteMoviesIds = favoriteMovies.compactMap({ $0.id })
        let isFavorite = favoriteMoviesIds.contains(id)
        presenter?.favoriteMovie(isFavorite: isFavorite)
    }

    func toggleFavorite(movie: MovieDetailsConfig, newState: Bool) {
        if newState {
            UserDefaultsManager.appendFavoriteMovieObject(movie)
        } else {
            UserDefaultsManager.removeFavoriteMovieObject(movie)
        }

        presenter?.favoriteMovieUpdated(newState: newState)
    }
    
    private func formatAsCurrency(value: Double, locale: Locale = Locale(identifier: "en_US"), decimalPlaces: Int = 0) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.minimumFractionDigits = decimalPlaces
        formatter.maximumFractionDigits = decimalPlaces
        
        return formatter.string(from: NSNumber(value: value))
    }
    
    private func formatDecimal(_ value: Double) -> Double {
        return (value * 10).rounded() / 10
    }
    
    private func getMovieDetailsConfig(_ details: MovieDetails?) -> MovieDetailsConfig {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var formattedDate = details?.releaseDate ?? ""
        if let date = dateFormatter.date(from: details?.releaseDate ?? "") {
            formattedDate = date.toString()
        }
        
        let duration: String = "\(details?.runtime ?? 0) min"
        let budget = formatAsCurrency(value: Double(details?.budget ?? 0))
        let revenue = formatAsCurrency(value: Double(details?.revenue ?? 0))
        let vote = "\(formatDecimal(details?.voteAverage ?? 0.0))"

        let backdropURL: URL? = URL(string: BaseUrls.images.rawValue + (details?.backdropPath ?? ""))
        let favorites = UserDefaultsManager.getFavoriteMoviesObjects()
        let favoriteIds = favorites.compactMap({ $0.id })

        return .init(
            title: details?.title,
            originalTitle: details?.originalTitle,
            releaseDate: formattedDate,
            duration: duration,
            budget: budget,
            revenue: revenue,
            vote: vote,
            overview: details?.overview,
            id: details?.id,
            imageURL: backdropURL,
            image: nil,
            isFavorited: favoriteIds.contains(details?.id ?? 0)
        )
    }

}
