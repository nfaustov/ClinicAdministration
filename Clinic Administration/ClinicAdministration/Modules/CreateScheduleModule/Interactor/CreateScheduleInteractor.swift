//
//  CreateScheduleInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation

final class CreateScheduleInteractor {
    typealias Delegate = CreateScheduleInteractorDelegate
    weak var delegate: Delegate?
}

// MARK: - CreateScheduleInteraction

extension CreateScheduleInteractor: CreateScheduleInteraction {
}
