//
//  GraphicTimeTablePreviewModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

protocol GraphicTimeTablePreviewModule: AnyObject {
    var didFinish: ((DoctorSchedule) -> Void)? { get set }
}

protocol GraphicTimeTablePreviewDisplaying: View {
    var newSchedule: DoctorSchedule! { get set }

    func applySchedules(_ schedules: [DoctorSchedule])
}

protocol GraphicTimeTablePreviewPresentation: AnyObject {
    func didFinish(with schedule: DoctorSchedule)
    func updateNewSchedule(_ schedule: DoctorSchedule)
    func scheduleDidUpdated(_ schedule: DoctorSchedule)
    func didSelected(date: Date)
}

protocol GraphicTimeTablePreviewInteraction: Interactor {
    func getSchedules(for date: Date)
    func updateSchedule(_ schedule: DoctorSchedule)
}

protocol GraphicTimeTablePreviewInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
}
