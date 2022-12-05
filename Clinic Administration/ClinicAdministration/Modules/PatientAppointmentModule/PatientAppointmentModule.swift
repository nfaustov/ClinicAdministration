//
//  PatientAppointmentModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.11.2021.
//

import Foundation

protocol PatientAppointmentModule: AnyObject {
    var coordinator: ScheduleCoordinator? { get set }
    var didFinish: ((DoctorSchedule?) -> Void)? { get set }
}

protocol PatientAppointmentView: View {
    var schedule: DoctorSchedule! { get set }
    func showError(message: String)
}

protocol PatientAppointmentPresentation: AnyObject {
    func updateSchedule(with newAppointment: PatientAppointment)
}

protocol PatientAppointmentInteraction: Interactor {
    func updateSchedule(_ schedule: DoctorSchedule)
}

protocol PatientAppointmentInteractorDelegate: AnyObject {
}
