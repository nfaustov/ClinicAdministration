//
//  PatientAppointmentModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.11.2021.
//

import Foundation

protocol PatientAppointmentModule: AnyObject {
    var coordinator: TimeTableCoordinator? { get set }
    var didFinish: ((DoctorSchedule?) -> Void)? { get set }
}

protocol PatientAppointmentView: View {
}

protocol PatientAppointmentPresentation: AnyObject {
}

protocol PatientAppointmentInteraction: Interactor {
}

protocol PatientAppointmentInteractorDelegate: AnyObject {
}
