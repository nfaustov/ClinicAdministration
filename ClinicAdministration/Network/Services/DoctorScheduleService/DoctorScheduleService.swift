//
//  DoctorScheduleService.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.12.2022.
//

import Foundation
import Combine

protocol DoctorScheduleService: AnyObject {
    var networkController: NetworkControllerProtocol { get }

    func create(_ doctorSchedule: DoctorSchedule) -> AnyPublisher<DoctorSchedule, Error>
    func getSchedulesByDate(_ date: Date) -> AnyPublisher<[DoctorSchedule], Error>
    func getSchedulesByDoctor(_ doctorID: UUID?) -> AnyPublisher<[DoctorSchedule], Error>
    func updateSchedule(_ schedule: DoctorSchedule) -> AnyPublisher<DoctorSchedule, Error>
    func deleteSchedule(_ scheduleID: UUID?) -> AnyPublisher<Bool, Error>
}
