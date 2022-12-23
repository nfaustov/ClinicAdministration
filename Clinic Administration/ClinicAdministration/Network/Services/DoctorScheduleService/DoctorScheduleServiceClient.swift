//
//  DoctorScheduleServiceClient.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.12.2022.
//

import Foundation
import Combine

final class DoctorScheduleServiceClient: DoctorScheduleService {
    let networkController: NetworkControllerProtocol

    init(networkController: NetworkControllerProtocol = NetworkController()) {
        self.networkController = networkController
    }

    func create(_ doctorSchedule: DoctorSchedule) -> AnyPublisher<DoctorSchedule, Error> {
        networkController.request(
            method: .post,
            endpoint: DoctorScheduleEndpoint.create(doctorSchedule)
        )
    }

    func getSchedulesByDate(_ date: Date) -> AnyPublisher<[DoctorSchedule], Error> {
        networkController.request(
            method: .get,
            endpoint: DoctorScheduleEndpoint.getByDate(date)
        )
    }

    func getSchedulesByDoctor(_ doctorID: UUID?) -> AnyPublisher<[DoctorSchedule], Error> {
        networkController.request(
            method: .get,
            endpoint: DoctorScheduleEndpoint.getByDoctor(doctorID)
        )
    }

    func updateSchedule(_ schedule: DoctorSchedule) -> AnyPublisher<DoctorSchedule, Error> {
        networkController.request(
            method: .put,
            endpoint: DoctorScheduleEndpoint.update(schedule)
        )
    }

    func deleteSchedule(_ scheduleID: UUID?) -> AnyPublisher<DoctorSchedule, Error> {
        networkController.request(
            method: .delete,
            endpoint: DoctorScheduleEndpoint.delete(scheduleID)
        )
    }
}
