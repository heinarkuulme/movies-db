//
//  MoviesService.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import Foundation

class MoviesService {
    enum Endpoints: RequestBase {
        case discover
        case search(query: String)
        
        var path: String {
            switch self {
            case .discover:
                "/discover/movie"
            case .search(let query):
                "/search/movie?query=\(query)"
            }
        }
        
        var method: RequestMethods {
            switch self {
            default: .get
            }
        }
        
        var header: [String : String]? {
            switch self {
            default: nil
            }
        }
        
        var params: [String : Any]? {
            switch self {
            default: nil
            }
        }
        
        var baseUrl: String {
            switch self {
            default: BaseUrls.common.rawValue
            }
        }
    }
}
