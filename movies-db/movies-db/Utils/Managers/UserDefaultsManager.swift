//
//  UserDefaultsManager.swift
//  movies-db
//
//  Created by Heinar Kuulme on 17/02/25.
//

import Foundation
import UIKit

enum UserDefaultsManager: String {
    case favoriteMoviesObjects
    
    //Salvar valores primitivos
    func setValue(_ value: Any?) {
        let defaults = UserDefaults.standard
        defaults.setValue(value, forKey: self.rawValue)
    }
    
    //Get de valores primitivos
    func getValue() -> Any? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: self.rawValue)
    }
    
    func setObject(object: Codable?) {
        let defaults = UserDefaults.standard
        var data: Data?
        
        if let object = object {
            data = try? JSONEncoder().encode(object)
        }
        defaults.set(data, forKey: self.rawValue)
    }
    
    static func getFavoriteMoviesObjects() -> [MovieDetailsConfig] {
        let defaults = UserDefaults.standard
        guard let array = defaults.object(forKey: UserDefaultsManager.favoriteMoviesObjects.rawValue) as? [[String: Any]] else {
            return []
        }
        return array.compactMap { MovieDetailsConfig(dictionary: $0) }
    }

    static func appendFavoriteMovieObject(_ movie: MovieDetailsConfig) {
        var movies = getFavoriteMoviesObjects()
        movies.append(movie)
        let moviesDict = movies.map { $0.toDictionary() }
        UserDefaults.standard.set(moviesDict, forKey: UserDefaultsManager.favoriteMoviesObjects.rawValue)
    }
    
    static func removeFavoriteMovieObject(_ movie: MovieDetailsConfig) {
        var movies = getFavoriteMoviesObjects()
        movies.removeAll { $0.id == movie.id }
        let moviesDict = movies.map { $0.toDictionary() }
        UserDefaults.standard.set(moviesDict, forKey: UserDefaultsManager.favoriteMoviesObjects.rawValue)
    }
}
