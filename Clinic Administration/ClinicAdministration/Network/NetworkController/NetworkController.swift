//
//  NetworkController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 20.12.2022.
//

import Foundation
import Combine

final class NetworkController: NetworkControllerProtocol {
    func post<T>(type: T.Type, url: URL, headers: Headers, body: Data?) -> AnyPublisher<T, Error> where T: Decodable {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = body
        urlRequest.httpMethod = "POST"
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func get<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> where T: Decodable {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func put<T>(type: T.Type, url: URL, headers: Headers, body: Data?) -> AnyPublisher<T, Error> where T: Codable {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = body
        urlRequest.httpMethod = "PUT"
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func delete<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> where T: Codable {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
