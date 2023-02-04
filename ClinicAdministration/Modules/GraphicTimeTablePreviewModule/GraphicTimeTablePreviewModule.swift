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

protocol GraphicTimeTablePreviewView: View {
    var newSchedule: DoctorSchedule! { get set }

    func applySchedules(_ schedules: [DoctorSchedule])
    func errorAlert(message: String)
    func successAlert(message: String)
}

protocol GraphicTimeTablePreviewPresentation: AnyObject {
    func saveNewSchedule(_ schedule: DoctorSchedule)
    func updateNewSchedule(_ schedule: DoctorSchedule)
    func updateSchedule(_ schedule: DoctorSchedule)
    func didSelected(date: Date)
}

protocol GraphicTimeTablePreviewInteraction: Interactor {
    func getSchedules(for date: Date)
    func updateSchedule(_ schedule: DoctorSchedule)
    func createSchedule(_ schedule: DoctorSchedule)
}

protocol GraphicTimeTablePreviewInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
    func scheduleDidUpdated(_ schedule: DoctorSchedule)
    func scheduleDidCreated(_ schedule: DoctorSchedule)
    func scheduleFailure(message: String)
}
