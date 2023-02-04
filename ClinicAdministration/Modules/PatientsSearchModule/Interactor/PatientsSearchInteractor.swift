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
        let patients: [Patient] = [
            Patient(
                secondName: "Абаканов",
                firstName: "Леонид",
                patronymicName: "Сергеевич",
                phoneNumber: "+7 (904) 298-03-33"
            ),
            Patient(
                secondName: "Ролдугин",
                firstName: "Сергей",
                patronymicName: "Иванович",
                phoneNumber: "+7 (933) 808-92-15"
            ),
            Patient(
                secondName: "Кирсанов",
                firstName: "Олег",
                patronymicName: "Ефремович",
                phoneNumber: "+7 (915) 245-24-33"
            )
        ]

        delegate?.patientsDidRecieved(patients)
    }
}
