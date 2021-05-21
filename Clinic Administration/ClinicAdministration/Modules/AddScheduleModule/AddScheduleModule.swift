//
//  AddScheduleModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

protocol AddScheduleModule: AnyObject {
    var didFinish: (() -> Void)? { get set }
}

protocol AddScheduleDisplaying: View {
    var newSchedule: DoctorSchedule! { get }

    func applySchedules(_ schedules: [DoctorSchedule])
}

protocol AddSchedulePresentation: AnyObject {
    func didSelected(date: Date)
    func addSchedule(_ schedule: DoctorSchedule)
}

protocol AddScheduleInteraction: Interactor {
    func getSchedules(for date: Date)
    func addSchedule(_ schedule: DoctorSchedule)
}

protocol AddScheduleInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
}
