//
//  NetworkResponse.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import Foundation

open class NetworkResponse<T: Codable> {
    public var response: T?
    
    public required init(response: T? = nil) {
        self.response = response
    }
    
    internal func parseData(data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as DecodingError {
            throw NetworkError(error: error)
        }
    }
}
