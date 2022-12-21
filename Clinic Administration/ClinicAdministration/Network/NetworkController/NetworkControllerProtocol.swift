//
//  NetworkControllerProtocol.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 20.12.2022.
//

import Foundation
import Combine

protocol NetworkControllerProtocol: AnyObject {
    typealias Headers = [String: String]

    func post<T>(type: T.Type, url: URL, headers: Headers, body: Data?) -> AnyPublisher<T, Error> where T: Codable
    func get<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> where T: Codable
    func put<T>(type: T.Type, url: URL, headers: Headers, body: Data?) -> AnyPublisher<T, Error> where T: Codable
    func delete<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> where T: Codable
}
