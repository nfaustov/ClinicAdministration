//
//  DoctorsSearchInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 03.06.2021.
//

import Foundation

final class DoctorsSearchInteractor {
    typealias Delegate = DoctorsSearchInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorsDatabase?
}

// MARK: - DoctorsSearchInteraction

extension DoctorsSearchInteractor: DoctorsSearchInteraction {
    func getDoctors() {
        guard let doctorsEntities = database?.readDoctors() else { return }

        let doctors = doctorsEntities.compactMap { Doctor(entity: $0) }
        delegate?.doctorsDidRecieved(doctors)
    }
}
