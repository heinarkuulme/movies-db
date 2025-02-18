//
//  MoviesListInteractor.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

class MoviesListInteractor: MoviesListInteractorInputProtocol {

    weak var presenter: MoviesListInteractorOutputProtocol?
    
    func fetchMovies(page: Int) {
        MoviesService.Endpoints.discover(page: page)
            .makeRequest(printResponse: true) { (result: Result<MoviesListResponse, NetworkError>) in
                
                switch result {
                case .success(let moviesResponse):
                    if let moviesList = moviesResponse.response {
                        let totalPages = moviesList.totalPages ?? 1
                        let configs = self.getMoviesConfig(moviesList.results)
                        self.presenter?.moviesFetched(configs, page: page, totalPages: totalPages)
                    }
                case .failure(let error):
                    print("Interactor Error: \(error)")
                }
            }
    }
    
    func searchMovies(query: String, page: Int) {
        MoviesService.Endpoints.search(query: query, page: page)
            .makeRequest(printResponse: true) { (result: Result<MoviesListResponse, NetworkError>) in
                switch result {
                case .success(let moviesResponse):
                    if let moviesList = moviesResponse.response {
                        let totalPages = moviesList.totalPages ?? 1
                        let configs = self.getMoviesConfig(moviesList.results)
                        self.presenter?.moviesFetched(configs, page: page, totalPages: totalPages)
                    }
                case .failure(let error):
                    print("Interactor Error: \(error)")
                }
            }
    }
    
    private func getMoviesConfig(_ movies: [Movie]?) -> [MovieGridConfig] {
        let configs: [MovieGridConfig] = movies?.compactMap { movie in
            guard let id = movie.id,
                  let title = movie.title,
                  let voteAverage = movie.voteAverage,
                  let posterPath = movie.posterPath,
                  let releaseDate = movie.releaseDate else {
                return nil
            }
            
            let coverURL: URL? = URL(string: BaseUrls.images.rawValue + posterPath)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            var formattedDate = releaseDate
            if let date = dateFormatter.date(from: releaseDate) {
                formattedDate = date.toString()
            }
            
            let favoriteMovies = UserDefaultsManager.getFavoritedMovies()
            
            return MovieGridConfig(
                id: id,
                title: title,
                releaseDate: formattedDate,
                coverURL: coverURL,
                rating: Float(voteAverage),
                isFavorited: favoriteMovies.contains(id)
            )
        } ?? []
        return configs
    }
    
}
