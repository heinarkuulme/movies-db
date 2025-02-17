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
        
        var path: String {
            switch self {
            case .discover:
                "/discover/movie"
            case .search(let query, let page):
                "/search/movie?query=\(query)&page=\(page)"
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
            }
        }
        
        var baseUrl: String {
            switch self {
            default: BaseUrls.common.rawValue
            }
        }
        
        var enconding: RequestEncondig {
            switch self {
            default: .url
            }
        }
    }
}
