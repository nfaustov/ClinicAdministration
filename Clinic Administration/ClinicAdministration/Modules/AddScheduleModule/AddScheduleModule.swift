//
//  AddScheduleModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

protocol AddScheduleModule: AnyObject {
    var didFinish: ((DoctorSchedule?) -> Void)? { get set }
}

protocol AddScheduleDisplaying: View {
    var newSchedule: DoctorSchedule! { get set }

    func applySchedules(_ schedules: [DoctorSchedule])
}

protocol AddSchedulePresentation: AnyObject {
    func didSelected(date: Date)
    func addSchedule(_ schedule: DoctorSchedule)
    func updateNewSchedule(_ schedule: DoctorSchedule)
    func scheduleDidUpdated(_ schedule: DoctorSchedule)
}

protocol AddScheduleInteraction: Interactor {
    func getSchedules(for date: Date)
    func addSchedule(_ schedule: DoctorSchedule)
    func updateSchedule(_ schedule: DoctorSchedule)
}

protocol AddScheduleInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
}
