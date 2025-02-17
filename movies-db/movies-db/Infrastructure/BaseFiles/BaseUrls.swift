//
//  BaseUrls.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import Foundation

//Classe para lidar com possíveis URLs diferentes dentro do app
enum BaseUrls: String {
    case common
    case images
    
    var rawValue: String {
        switch self {
        case .common:
            return InfoPlistManager.getValue(key: .BaseUrl) ?? ""
        case .images:
            return InfoPlistManager.getValue(key: .BaseImageUrl) ?? ""
        }
    }
}
