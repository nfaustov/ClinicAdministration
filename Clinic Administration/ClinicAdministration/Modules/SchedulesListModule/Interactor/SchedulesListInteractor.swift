//
//  SchedulesListInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.10.2021.
//

import Foundation

final class SchedulesListInteractor {
    typealias Delegate = SchedulesListInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorsDatabase?
}

// MARK: - SchedulesListInteraction

extension SchedulesListInteractor: SchedulesListInteraction {
}
