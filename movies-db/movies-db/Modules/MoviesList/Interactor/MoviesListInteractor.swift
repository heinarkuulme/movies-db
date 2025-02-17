//
//  MoviesListInteractor.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

class MoviesListInteractor: MoviesListInteractorInputProtocol {
    
    weak var presenter: MoviesListInteractorOutputProtocol?
    
    func fetchMovies() {
        MoviesService.Endpoints.discover
            .makeRequest(printResponse: true) { (result: Result<MoviesListResponse, NetworkError>) in
                
                switch result {
                case .success(let moviesResponse):
                    if let moviesList = moviesResponse.response {
                        self.presenter?.moviesFetched(moviesList)
                    }
                case .failure(let error):
                    print("Interactor Error: \(error)")
                }
            }
    }
    
    func getMoviesConfig(_ movies: [Movie]) {
        let configs: [MovieGridConfig] = movies.compactMap { movie in
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
                isFavorited: false
            )
        }
        
        presenter?.moviesConfigFacade(configs)
    }
    
}
