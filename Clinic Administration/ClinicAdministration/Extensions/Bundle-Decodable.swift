//
//  Bundle-Decodable.swift
//  
//
//  Created by Nikolai Faustov on 26.03.2021.
//

import Foundation

enum DateFormat: String {
    /// "yyyy-MM-dd'T'HH:mm"
    case standard = "yyyy-MM-dd'T'HH:mm"
}

extension Bundle {
    /// Decodes an instance of the indicated type from specified JSON file in `Bundle`
    /// - Parameters:
    ///   - type: Decoded instance type
    ///   - file: File name
    ///   - dateFormat: Date format for decodeing dates
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateFormat: DateFormat? = nil) -> T {
        guard let url = self.url(forResource: file, withExtension: "json") else {
            fatalError("Failed to locale \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        DateFormatter.shared.dateFormat = dateFormat?.rawValue
        decoder.dateDecodingStrategy = .formatted(DateFormatter.shared)

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}
