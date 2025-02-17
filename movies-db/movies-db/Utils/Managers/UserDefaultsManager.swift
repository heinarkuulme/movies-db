//
//  UserDefaultsManager.swift
//  movies-db
//
//  Created by Heinar Kuulme on 17/02/25.
//

import Foundation
import UIKit

enum UserDefaultsManager: String {
    case favoriteMovies
    
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
    
    static func getFavoritedMovies() -> [Int] {
        let defaults = UserDefaults.standard
        guard let data = defaults.object(forKey: UserDefaultsManager.favoriteMovies.rawValue) as? Data else {
            return []
        }
        
        return (try? JSONDecoder().decode([Int].self, from: data)) ?? []
    }
}
