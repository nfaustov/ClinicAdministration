//
//  PatientCardModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.12.2022.
//

import Foundation

protocol PatientCardModule: AnyObject {
    var coordinator: ScheduleCoordinator? { get set }
}

protocol PatientCardView: View {
}

protocol PatientCardPresentation: AnyObject {
    func showPassportData(for: Patient)
    func createCheck(for: Patient)
}

protocol PatientCardInteraction: Interactor {
}

protocol PatientCardInteractorDelegate: AnyObject {
}
