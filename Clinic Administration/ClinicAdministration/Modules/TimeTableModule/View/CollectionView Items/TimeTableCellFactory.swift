//
//  TimeTableCellFactory.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 07.04.2021.
//

import UIKit

final class TimeTableCellFactory {
    private let collectionView: UICollectionView

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    func getCell(with model: AnyHashable, for indexPath: IndexPath) -> UICollectionViewCell {
        if let doctor = model as? DoctorSchedule {
            return configureCell(DoctorCell.self, with: doctor, for: indexPath)
        } else if let patient = model as? TimeTablePatientCell {
            return configureCell(PatientCell.self, with: patient, for: indexPath)
        } else if let action = model as? TimeTableAction {
            return configureCell(ActionListCell.self, with: action, for: indexPath)
        } else if let placeholder = model as? DoctorSectionPlaceholder {
            return configureCell(DoctorPlaceholder.self, with: placeholder, for: indexPath)
        } else if let control = model as? DoctorControl {
            return configureCell(DoctorControlCell.self, with: control, for: indexPath)
        } else {
            fatalError("Unknown model type")
        }
    }

    private func configureCell<T>(
        _ cellType: T.Type,
        with model: T.Model,
        for indexPath: IndexPath
    ) -> T where T: TimeTableCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue cell")
        }

        cell.configure(with: model)

        return cell
    }
}
