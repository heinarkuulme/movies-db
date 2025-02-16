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
//                        print("Interactor: \(moviesList)")
                    }
                case .failure(let error):
                    print("Interactor Error: \(error)")
                }
                
            }
        
    }
    
}
