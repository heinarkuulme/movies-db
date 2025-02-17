//
//  MoviesListInteractor.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

class MoviesListInteractor: MoviesListInteractorInputProtocol {

    weak var presenter: MoviesListInteractorOutputProtocol?
    
    func fetchMovies(page: Int, favoriteMovies: [Int]) {
        MoviesService.Endpoints.discover(page: page)
            .makeRequest(printResponse: true) { (result: Result<MoviesListResponse, NetworkError>) in
                
                switch result {
                case .success(let moviesResponse):
                    if let moviesList = moviesResponse.response {
                        let totalPages = moviesList.totalPages ?? 1
                        let configs = self.getMoviesConfig(moviesList.results, favoriteMovies: favoriteMovies)
                        self.presenter?.moviesFetched(configs, page: page, totalPages: totalPages)
                    }
                case .failure(let error):
                    print("Interactor Error: \(error)")
                }
            }
    }
    
    func fetchFavoriteMovies() {
        let favoriteMovies = UserDefaultsManager.getFavoritedMovies()
        presenter?.favoriteMoviesFetched(ids: favoriteMovies)
    }

    func toggleFavorite(for movie: MovieGridConfig) {
        var favorites = UserDefaultsManager.getFavoritedMovies()
        let newState: Bool

        if favorites.contains(movie.id) {
            favorites.removeAll { $0 == movie.id }
            newState = false
        } else {
            favorites.append(movie.id)
            newState = true
        }

        UserDefaultsManager.favoriteMovies.setObject(object: favorites)
        presenter?.favoriteMovieUpdated(ids: favorites, for: movie.id, newState: newState)
    }
    
    private func getMoviesConfig(_ movies: [Movie]?, favoriteMovies: [Int]) -> [MovieGridConfig] {
        let configs: [MovieGridConfig] = movies?.compactMap { movie in
            guard let id = movie.id,
                  let title = movie.title,
                  let voteAverage = movie.voteAverage,
                  let posterPath = movie.posterPath,
                  let releaseDate = movie.releaseDate else {
                return nil
            }
            
            let coverURL: URL? = URL(string: BaseUrls.images.rawValue + posterPath)
            
            return MovieGridConfig(
                id: id,
                title: title,
                releaseDate: releaseDate,
                coverURL: coverURL,
                rating: Float(voteAverage),
                isFavorited: favoriteMovies.contains(id)
            )
        } ?? []
        return configs
    }
    
}
