//
//  Extension+Date.swift
//  movies-db
//
//  Created by Heinar Kuulme on 17/02/25.
//

import Foundation

extension Date {
    func toString(withFormat format: String = "dd-MM-yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
