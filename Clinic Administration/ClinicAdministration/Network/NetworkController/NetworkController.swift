//
//  NetworkController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 20.12.2022.
//

import Foundation
import Combine

final class NetworkController: NetworkControllerProtocol {
    func request<T>(method: HttpMethod, endpoint: Endpoint) -> AnyPublisher<T, Error> where T: Codable {
        let urlRequest = makeRequest(method: method, endpoint: endpoint)

        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = "dd-MM-yyyy'T'HH:mm"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ [httpError] data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw httpError(0)
                }

                Log.info("Status code: \(response.statusCode) '\(urlRequest.url!)'")

                if !(200...299).contains(response.statusCode) {
                    throw httpError(response.statusCode)
                }

                return data
            })
            .receive(on: RunLoop.main)
            .decode(type: T.self, decoder: decoder)
            .mapError({ [handleError] error in
                Log.error("\(error)")
                return handleError(error)
            })
            .eraseToAnyPublisher()
    }

    func deleteRequest(endpoint: Endpoint) -> AnyPublisher<Bool, Error> {
        let urlRequest = makeRequest(method: .delete, endpoint: endpoint)

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ [httpError] _ , response in

                guard let response = response as? HTTPURLResponse else {
                    throw httpError(0)
                }

                Log.info("Status code: \(response.statusCode) '\(urlRequest.url!)'")

                if !(200...299).contains(response.statusCode) {
                    throw httpError(response.statusCode)
                }

                return true
            })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - Private methods

extension NetworkController {
    private func makeRequest(method: HttpMethod, endpoint: Endpoint) -> URLRequest {
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.httpBody = endpoint.body
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers

        Log.info("(\(urlRequest.httpMethod!)) '\(urlRequest.url!)'")

        return urlRequest
    }

    private func handleError(_ error: Error) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError(error.localizedDescription)
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkRequestError:
            return error
        default:
            return .unknownError
        }
    }

    private func httpError(_ statusCode: Int) -> NetworkRequestError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
}

enum NetworkRequestError: LocalizedError {
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case error4xx(_ code: Int)
    case serverError
    case error5xx(_ code: Int)
    case decodingError( _ description: String)
    case urlSessionFailed(_ error: URLError)
    case timeOut
    case unknownError
}
