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
            return configureDoctorCell(with: doctor, for: indexPath)
        } else if let patient = model as? TimeTablePatientCell {
            return configurePatientCell(with: patient, for: indexPath)
        } else if let action = model as? TimeTableAction {
            return configureActionListCell(with: action, for: indexPath)
        } else {
            fatalError("Unknown model type")
        }
    }

    private func configureDoctorCell(with model: DoctorSchedule, for indexPath: IndexPath) -> DoctorCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DoctorCell.reuseIdentifier,
                for: indexPath
        ) as? DoctorCell else {
            fatalError("Unable to dequeue cell")
        }

        cell.configure(with: model)

        return cell
    }

    private func configurePatientCell(with model: TimeTablePatientCell, for indexPath: IndexPath) -> PatientCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PatientCell.reuseIdentifier,
                for: indexPath
        ) as? PatientCell else {
            fatalError("Unable to dequeue cell")
        }

        cell.configure(with: model)

        return cell
    }

    private func configureActionListCell(with model: TimeTableAction, for indexPath: IndexPath) -> ActionListCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ActionListCell.reuseIdentifier,
                for: indexPath
        ) as? ActionListCell else {
            fatalError("Unable to dequeue cell")
        }

        cell.configure(with: model)

        return cell
    }
}
