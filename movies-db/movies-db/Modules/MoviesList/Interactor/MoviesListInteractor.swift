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
            .makeRequest(printResponse: true) { [weak self] (result: Result<MoviesListResponse, NetworkError>) in
                guard let self = self else { return }

                switch result {
                case .success(let moviesResponse):
                    if let moviesList = moviesResponse.response {
                        let totalPages = moviesList.totalPages ?? 1
                        let configs = self.getMoviesConfig(moviesList.results)
                        self.presenter?.moviesFetched(configs, page: page, totalPages: totalPages)
                    }
                case .failure(let error):
                    self.presenter?.moviesFetchedFailed(error: error.message)
                }
            }
    }
    
    func searchMovies(query: String, page: Int) {
        MoviesService.Endpoints.search(query: query, page: page)
            .makeRequest(printResponse: true) { [weak self] (result: Result<MoviesListResponse, NetworkError>) in
                guard let self = self else { return }

                switch result {
                case .success(let moviesResponse):
                    if let moviesList = moviesResponse.response {
                        let totalPages = moviesList.totalPages ?? 1
                        let configs = self.getMoviesConfig(moviesList.results)
                        self.presenter?.moviesFetched(configs, page: page, totalPages: totalPages)
                    }
                case .failure(let error):
                    self.presenter?.moviesFetchedFailed(error: error.message)
                }
            }
    }
    
    func refreshFavorites(movies: [MovieGridConfig]) {
        let favoriteMovies = UserDefaultsManager.getFavoriteMoviesObjects()
        let favoriteMoviesIds: [Int] = favoriteMovies.compactMap({ $0.id })
        
        let newMovies: [MovieGridConfig] = movies.compactMap { movie in
            return MovieGridConfig(
                id: movie.id,
                title: movie.title,
                releaseDate: movie.releaseDate,
                coverURL: movie.coverURL,
                rating: movie.rating,
                isFavorited: favoriteMoviesIds.contains(movie.id)
            )
        }
        presenter?.updatedFavoritesFetched(newMovies)
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
            
            let favoriteMovies = UserDefaultsManager.getFavoriteMoviesObjects()
            let favoriteMoviesIds: [Int] = favoriteMovies.compactMap({ $0.id })
            
            return MovieGridConfig(
                id: id,
                title: title,
                releaseDate: formattedDate,
                coverURL: coverURL,
                rating: Float(voteAverage),
                isFavorited: favoriteMoviesIds.contains(id)
            )
        } ?? []
        return configs
    }
    
}

/// Eu optei por ter um componente de imagem (CustomImageView) que gere o download de imagens e centralizada o cache delas em só lugar.
/// dessa forma eu posso só trafegar o path da imagem entre as classes do modulo, acredito que dessa forma fique mais simples, e não preciso sempre notificar a view que temos uma nova imagem
/// o componente lida sozinho com isso
/// de qualquer forma vou deixar uma função (que não está sendo utilizada) de como seria a implementação baixando as imagens uma a uma aqui no interactor
/// utilizando uma fila serial para ser thread safety, além de atualizar a view na main thread

/// nesse exemplo as imagens seriam atualizadas uma a uma, outra possibilidade seria baixar todas de uma vez e atualizar a view somente uma vez
/// nesse caso eu utilizaria um dispatchGroup
extension MoviesListInteractor {
    func downloadImages(for movies: [MovieGridConfig]) {
        let serialQueue = DispatchQueue(label: "movies-db.imageDownloads")
        
        for movie in movies {
            guard let url = movie.coverURL else { continue }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    serialQueue.async {
                        var updatedMovie = movie
                        ///não tenho a uiimage na model atualmente, mas nesse cenário seria necessário criar
                        //updatedMovie.image = image
                        DispatchQueue.main.async {
                            ///não tenho a função no protocolo da presenter, nesse cenário seria necessário criar
                            ///e dentro dela atualizar a view
                            //self.presenter?.movieImageUpdated(movie: updatedMovie)
                        }
                    }
                }
            }.resume()
        }
    }
}
