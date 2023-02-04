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
    var queryParams: [String: Any]? { get set }
}

extension Endpoint {
    var url: URL {
        var urlComponents = URLComponents(string: BaseURL.localhost + path)

        if let queryParams = queryParams {
            urlComponents?.queryItems = queryParams.map({ URLQueryItem(name: $0.key, value: "\($0.value)") })
        }

        guard let url = urlComponents?.url else {
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
