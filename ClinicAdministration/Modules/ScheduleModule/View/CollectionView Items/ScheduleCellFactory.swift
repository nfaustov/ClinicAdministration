//
//  ScheduleCellFactory.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 07.04.2021.
//

import UIKit

final class ScheduleCellFactory: CellFactory {
    override func makeCell(with model: AnyHashable, for indexPath: IndexPath) -> UICollectionViewCell {
        if let schedule = model as? DoctorSchedule {
            return configureCell(DoctorCell.self, with: schedule, for: indexPath)
        } else if let patient = model as? PatientAppointment {
            return configureCell(PatientCell.self, with: patient, for: indexPath)
        } else if let action = model as? ScheduleAction {
            return configureCell(ActionListCell.self, with: action, for: indexPath)
        } else if let placeholder = model as? DoctorSectionPlaceholder {
            return configureCell(DoctorPlaceholder.self, with: placeholder, for: indexPath)
        } else if let control = model as? DoctorControl {
            return configureCell(DoctorControlCell.self, with: control, for: indexPath)
        } else {
            fatalError("Unknown model type")
        }
    }
}
