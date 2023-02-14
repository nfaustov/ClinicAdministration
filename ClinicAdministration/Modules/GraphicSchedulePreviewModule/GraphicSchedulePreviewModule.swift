//
//  GraphicSchedulePreviewModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

protocol GraphicSchedulePreviewModule: AnyObject {
    var didFinish: ((DoctorSchedule) -> Void)? { get set }
}

protocol GraphicSchedulePreviewView: BaseView {
    var newSchedule: DoctorSchedule! { get set }

    func applySchedules(_ schedules: [DoctorSchedule])
    func errorAlert(message: String)
    func successAlert(message: String)
}

protocol GraphicSchedulePreviewPresentation: AnyObject {
    func saveNewSchedule(_ schedule: DoctorSchedule)
    func updateNewSchedule(_ schedule: DoctorSchedule)
    func updateSchedule(_ schedule: DoctorSchedule)
    func didSelected(date: Date)
}

protocol GraphicSchedulePreviewInteraction: BaseInteractor {
    func getSchedules(for date: Date)
    func updateSchedule(_ schedule: DoctorSchedule)
    func createSchedule(_ schedule: DoctorSchedule)
}

 protocol GraphicSchedulePreviewInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
    func scheduleDidUpdated(_ schedule: DoctorSchedule)
    func scheduleDidCreated(_ schedule: DoctorSchedule)
    func scheduleFailure(message: String)
}
