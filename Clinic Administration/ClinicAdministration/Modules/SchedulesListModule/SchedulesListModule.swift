//
//  SchedulesListModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.10.2021.
//

import Foundation

protocol SchedulesListModule: AnyObject {
    var didFinish: ((DoctorSchedule) -> Void)? { get set }
}

protocol SchedulesListDisplaying: View {
    func schedulesSnapshot(_ schedules: [DoctorSchedule])
}

protocol SchedulesListPresentation: AnyObject {
    func didFinish(with schedule: DoctorSchedule)
    func getSchedules(for doctor: Doctor, onDate: Date?)
}

protocol SchedulesListInteraction: Interactor {
    func getSchedules(for doctor: Doctor, onDate: Date?)
}

protocol SchedulesListInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
}
