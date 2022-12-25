//
//  DoctorScheduleEndpoint.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.12.2022.
//

import Foundation

struct DoctorScheduleEndpoint: Endpoint {
    var path: String
    var body: Data?
    var queryParams: [String: Any]?
}

extension DoctorScheduleEndpoint {
    static func create(_ doctorSchedule: DoctorSchedule) -> Self {
        guard let json = try? JSONEncoder().encode(doctorSchedule) else {
            preconditionFailure("Encoding Error")
        }

        return DoctorScheduleEndpoint(path: "/schedules", body: json)
    }

    static func getByDate(_ date: Date) -> Self {
        let seconds = date.timeIntervalSince1970
        let query = ["date": "\(seconds)"]

        return DoctorScheduleEndpoint(path: "/schedules", queryParams: query)
    }

    static func getByDoctor(_ doctorID: UUID?) -> Self {
        guard let id = doctorID?.uuidString else {
            preconditionFailure("Invalid ID")
        }

        return DoctorScheduleEndpoint(path: "/schedules/\(id)")
    }

    static func update(_ schedule: DoctorSchedule) -> Self {
        guard let id = schedule.id?.uuidString else {
            preconditionFailure("Invalid ID")
        }

        guard let json = try? JSONEncoder().encode(schedule) else {
            preconditionFailure("Encoding error")
        }

        return DoctorScheduleEndpoint(path: "/schedules/\(id)", body: json)
    }

    static func delete(_ scheduleID: UUID?) -> Self {
        guard let id = scheduleID?.uuidString else {
            preconditionFailure("Invalid ID")
        }

        return DoctorScheduleEndpoint(path: "/schedules/\(id)")
    }
}
