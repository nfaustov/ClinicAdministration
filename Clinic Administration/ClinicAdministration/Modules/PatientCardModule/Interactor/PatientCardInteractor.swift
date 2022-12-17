//
//  PatientCardInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.12.2022.
//

import Foundation

final class PatientCardInteractor {
    typealias Delegate = PatientCardInteractorDelegate
    weak var delegate: Delegate?
}

// MARK: - PatientCardInteraction

extension PatientCardInteractor: PatientCardInteraction {
}
