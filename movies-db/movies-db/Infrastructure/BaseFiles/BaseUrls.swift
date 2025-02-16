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
    
    var rawValue: String {
        switch self {
        case .common:
            return InfoPlistManager.getValue(key: .BaseUrl) ?? ""
        }
    }
}
