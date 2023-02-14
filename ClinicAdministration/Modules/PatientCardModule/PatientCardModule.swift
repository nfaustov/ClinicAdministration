//
//  PatientCardModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.12.2022.
//

import Foundation

protocol PatientCardModule: AnyObject {
    var coordinator: PatientCoordinator? { get set }
}

protocol PatientCardView: BaseView {
}

protocol PatientCardPresentation: AnyObject {
    func showPassportData(for: Patient)
    func createCheck(for: Patient)
}

protocol PatientCardInteraction: BaseInteractor {
}

protocol PatientCardInteractorDelegate: AnyObject {
}
