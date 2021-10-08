//
//  CreateScheduleCellFactory.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.06.2021.
//

import UIKit

final class CreateScheduleCellFactory: CellFactory {
    override func makeCell(with model: AnyHashable, for indexPath: IndexPath) -> UICollectionViewCell {
        if let doctor = model as? Doctor {
            return configureCell(DoctorViewCell.self, with: doctor, for: indexPath)
        } else if let option = model as? ScheduleOption {
            return configureCell(OptionCell.self, with: option, for: indexPath)
        } else if let interval = model as? DateInterval {
            return configureCell(IntervalCell.self, with: interval, for: indexPath)
        } else {
            fatalError("Unknown model type")
        }
    }
}
