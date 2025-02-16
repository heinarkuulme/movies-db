//
//  InfoPlistManager.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import Foundation

final class InfoPlistManager {
    
    enum plistKeys: String {
        case BaseUrl
        case ApiToken
    }
    
    class func getValue<T: Codable>(key: plistKeys) -> T? {
        return Bundle.main.infoDictionary?[key.rawValue] as? T
    }
}
