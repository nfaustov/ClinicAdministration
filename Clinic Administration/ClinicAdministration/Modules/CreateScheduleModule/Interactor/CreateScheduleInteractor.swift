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

    var database: DoctorsDatabase?
}

// MARK: - CreateScheduleInteraction

extension CreateScheduleInteractor: CreateScheduleInteraction {
    func getDoctors() {
        guard let database = database else { return }

        let doctorsEntities = database.readDoctors()
        let doctors = doctorsEntities.compactMap({ Doctor(entity: $0) })
        delegate?.doctorsDidRecieved(doctors)
    }
}
