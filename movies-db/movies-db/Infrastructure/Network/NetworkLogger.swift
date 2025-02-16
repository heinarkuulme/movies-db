//
//  NetworkLogger.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

enum LogEvent: String {
    case debug = "[🐛]" // debug
    case info = "[ℹ️]" // informação
    case warning = "[⚠️]" // Aviso
    case error = "[‼️]" // erro
}

class NetworkLogger {
    class func log(_ message: @autoclosure () -> String, event: LogEvent) {
        if isDebugEnabled {
            print("\(event.rawValue) \(message())")
        }
    }
}
