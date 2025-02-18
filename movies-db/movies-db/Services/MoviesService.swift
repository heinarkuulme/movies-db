//
//  MoviesService.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import Foundation

class MoviesService {
    enum Endpoints: RequestBase {
        case discover(page: Int)
        case search(query: String, page: Int)
        case details(id: Int)
        
        var path: String {
            switch self {
            case .discover:
                "/discover/movie"
            case .search:
                "/search/movie"
            case .details(let id):
                "/movie/\(id)"
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
            case .discover(let page):
                ["page": page]
            case .search(let query, let page):
                ["page": page, "query": query]
            default:
                nil
            }
        }
        
        var baseUrl: String {
            switch self {
            default: BaseUrls.common.rawValue
            }
        }
        
        var enconding: RequestEncondig {
            switch self {
            case .details: .json
            default: .url
            }
        }
    }
}
