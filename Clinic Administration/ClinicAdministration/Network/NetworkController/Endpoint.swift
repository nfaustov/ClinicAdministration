//
//  Endpoint.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.12.2022.
//

import Foundation

protocol Endpoint {
    var path: String { get set }
    var body: Data? { get set }
    var queryParams: [String: Any] { get set }
}

extension Endpoint {
    var url: URL {
        guard let url = URL(string: BaseURL.localhost + path) else {
            preconditionFailure("Invalid URL")
        }

        return url
    }

    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
}

enum BaseURL {
    static let localhost = "http://127.0.0.1:8080"
    static let test = ""
    static let production = "https://artmedics.ru/api/v0"
}
