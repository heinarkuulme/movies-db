//
//  NetworkError.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import Foundation

//Classe para tratamento de erros custom
struct NetworkError: Error, Codable {
    public let statusCode: Int
    public let message: String
    public let error: String
    
    var localizedDescription: String {
        return message
    }
    
    //common init
    init(statusCode: Int, message: String, error: String) {
        self.statusCode = statusCode
        self.message = message
        self.error = error
    }
    
    // erro genérico
    init(error: Error, statusCode: Int = -1) {
        self.statusCode = statusCode
        self.message = error.localizedDescription
        self.error = error.localizedDescription
    }
    
    init(error: DecodingError) {
        switch error {
        case .typeMismatch(let any, let context):
            self.statusCode = 601
            self.message = "Missmatch type: \(any), \(context)"
        case .valueNotFound(let any, let context):
            self.statusCode = 602
            self.message = "Value not found: \(any), \(context)"
        case .keyNotFound(let any, let context):
            self.statusCode = 603
            self.message = "Key not found: \(any), \(context)"
        case .dataCorrupted(let context):
            self.statusCode = 602
            self.message = "Data corrupted: \(context)"
        @unknown default:
            self.statusCode = 600
            self.message = "Unknown decoding error"
        }
        self.error = "Decoding"
    }
}
