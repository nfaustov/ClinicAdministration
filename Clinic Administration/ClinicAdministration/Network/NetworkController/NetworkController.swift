//
//  NetworkController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 20.12.2022.
//

import Foundation
import Combine

final class NetworkController: NetworkControllerProtocol {
    func request<T>(type: T.Type, method: HttpMethod, endpoint: Endpoint) -> AnyPublisher<T, Error> where T: Codable {
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.httpBody = endpoint.body
        urlRequest.httpMethod = method.rawValue
        endpoint.headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
