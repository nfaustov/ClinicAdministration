//
//  NetworkControllerProtocol.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 20.12.2022.
//

import Foundation
import Combine

protocol NetworkControllerProtocol: AnyObject {
    func request<T>(method: HttpMethod, endpoint: Endpoint) -> AnyPublisher<T, Error> where T: Codable
    func deleteRequest(endpoint: Endpoint) -> AnyPublisher<Bool, Error>
}

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
