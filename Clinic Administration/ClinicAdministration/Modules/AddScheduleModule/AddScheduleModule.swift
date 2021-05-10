//
//  AddScheduleModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

protocol AddScheduleModule: AnyObject {
    var didFinish: ((_ schedule: DoctorSchedule?) -> Void)? { get set }
}

protocol AddScheduleDisplaying: View {
    var newSchedule: DoctorSchedule! { get }

    func applySchedules(_ schedules: [DoctorSchedule])
}

protocol AddSchedulePresentation: AnyObject {
    func didFinish(with schedule: DoctorSchedule?)

    func didSelected(date: Date)
}

protocol AddScheduleInteraction: Interactor {
    func getSchedules(for date: Date)
}

protocol AddScheduleInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
}
