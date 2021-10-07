//
//  CreateScheduleCellFactory.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.06.2021.
//

import UIKit

final class CreateScheduleCellFactory {
    private let collectionView: UICollectionView

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    func getCell(with model: AnyHashable, for indexPath: IndexPath) -> UICollectionViewCell {
        if let doctor = model as? Doctor {
            return configureCell(DoctorViewCell.self, with: doctor, for: indexPath)
        } else if let option = model as? ScheduleOption {
            return configureCell(OptionCell.self, with: option, for: indexPath)
        } else {
            fatalError("Unknown model type")
        }
    }

    private func configureCell<T>(
        _ celltype: T.Type,
        with model: T.Model,
        for indexPath: IndexPath
    ) -> T where T: CreateScheduleCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: celltype.reuseIndentifier,
                for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue cell")
        }

        cell.configure(with: model)

        return cell
    }
}
