//
//  DoctorsSearchCellFactory.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 07.12.2022.
//

import UIKit

final class DoctorsSearchCellFactory: CellFactory {
    override func makeCell(with model: AnyHashable, for indexPath: IndexPath) -> UICollectionViewCell {
        if let doctor = model as? Doctor {
            return configureCell(DoctorItemCell.self, with: doctor, for: indexPath)
        } else if let specialization = model as? String {
            return configureCell(SpecializationCell.self, with: specialization, for: indexPath)
        } else {
            fatalError("Unknown model type")
        }
    }
}
