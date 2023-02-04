//
//  DoctorEndpoint.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 20.12.2022.
//

import Foundation

struct DoctorEndpoint: Endpoint {
    var path: String
    var body: Data?
    var queryParams: [String: Any]?
}

extension DoctorEndpoint {
    static var doctors: Self {
        DoctorEndpoint(path: "/doctors")
    }

    static func create(_ doctor: Doctor) -> Self {
        guard let json = try? JSONEncoder().encode(doctor) else {
            preconditionFailure("Encoding error")
        }

        return DoctorEndpoint(path: "/doctors", body: json)
    }

    static func doctor(_ doctorID: UUID?) -> Self {
        guard let id = doctorID?.uuidString else {
            preconditionFailure("Invalid ID")
        }

        return DoctorEndpoint(path: "/doctors/\(id)")
    }

    static func update(_ doctor: Doctor) -> Self {
        guard let id = doctor.id?.uuidString else {
            preconditionFailure("Invalid ID")
        }

        guard let json = try? JSONEncoder().encode(doctor) else {
            preconditionFailure("Encoding error")
        }

        return DoctorEndpoint(path: "/doctors/\(id)", body: json)
    }
}
