//
//  PatientsSearchInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 15.12.2022.
//

import Foundation

final class PatientsSearchInteractor {
    typealias Delegate = PatientsSearchInteractorDelegate
    weak var delegate: Delegate?
}

// MARK: - PatientsSearchInteraction

extension PatientsSearchInteractor: PatientsSearchInteraction {
    func getPatients() {
    }
}
