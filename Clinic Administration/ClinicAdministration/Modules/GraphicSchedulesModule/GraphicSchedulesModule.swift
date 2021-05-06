//
//  GraphicSchedulesModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

protocol GraphicSchedulesModule: AnyObject {
    var didFinish: ((_ schedule: DoctorSchedule?) -> Void)? { get set }
}

protocol GraphicSchedulesDisplaying: View {
    var date: Date! { get set }

    func applySchedules(_ schedules: [DoctorSchedule])
}

protocol GraphicSchedulesPresentation: AnyObject {
    func didFinish(with schedule: DoctorSchedule)

    func didSelected(date: Date)
}

protocol GraphicSchedulesInteraction: Interactor {
    func getSchedules(for date: Date)
}

protocol GraphicSchedulesInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
}
