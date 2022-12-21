//
//  DoctorEndpoint.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 20.12.2022.
//

import Foundation

struct DoctorEndpoint {
    var path: String = ""
    var body: Data?
    var queryParams: [String: Any] = [:]

    var url: URL {
        guard let url = URL(string: "http://127.0.0.1:8080/doctors" + path) else {
            preconditionFailure("Invalid URL")
        }

        return url
    }

    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
}

extension DoctorEndpoint {
    static var index: Self {
        DoctorEndpoint(path: "doctors/")
    }

    static func create(_ doctor: Doctor) -> Self {
        guard let json = try? JSONEncoder().encode(doctor.self) else {
            preconditionFailure("Decoding error")
        }

        return DoctorEndpoint(path: "doctors/", body: json)
    }

    static func doctor(_ doctorID: UUID?) -> Self {
        guard let id = doctorID?.uuidString else {
            preconditionFailure("Invalid ID")
        }

        return DoctorEndpoint(path: "doctors/\(id)")
    }

    static func update(_ doctor: Doctor) -> Self {
        guard let id = doctor.id?.uuidString else {
            preconditionFailure("Invalid ID")
        }

        guard let json = try? JSONEncoder().encode(doctor.self) else {
            preconditionFailure("Decoding error")
        }

        return DoctorEndpoint(path: "doctors/\(id)", body: json)
    }
}
