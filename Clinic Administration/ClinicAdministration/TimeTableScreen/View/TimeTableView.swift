//
//  TimeTableView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.03.2021.
//

import UIKit
import Design

final class TimeTableView: UIView {
    private enum Section: Int, Hashable {
        case doctor
        case patient
    }

    private var collectionView: UICollectionView!

    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?

    var output: TimeTableViewOutput!

    override init(frame: CGRect) {
        super.init(frame: frame)

        collectionView = UICollectionView(frame: frame, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = Design.Color.lightGray
        collectionView.delegate = self
        addSubview(collectionView)

        collectionView.register(DoctorCell.self, forCellWithReuseIdentifier: DoctorCell.reuseIdentifier)
        collectionView.register(PatientCell.self, forCellWithReuseIdentifier: PatientCell.reuseIdentifier)

        createDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            if let doctor = item as? DoctorSchedule {
                guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: DoctorCell.reuseIdentifier,
                        for: indexPath
                ) as? DoctorCell else {
                    fatalError("Unable to dequeue cell")
                }

                cell.configure(with: doctor)

                return cell
            } else if let patientCell = item as? TimeTablePatientCell {
                guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PatientCell.reuseIdentifier,
                        for: indexPath
                ) as? PatientCell else {
                    fatalError("Unable to dequeue cell")
                }

                cell.configure(with: patientCell)

                if indexPath.row == 0 {
                    cell.layer.cornerRadius = Design.CornerRadius.large
                    cell.layer.maskedCorners = .layerMinXMinYCorner
                } else if indexPath.row == 1 {
                    cell.layer.cornerRadius = Design.CornerRadius.large
                    cell.layer.maskedCorners = .layerMaxXMinYCorner
                } else {
                    cell.layer.cornerRadius = .zero
                }

                return cell
            } else {
                fatalError("Unknown item type")
            }
        }
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("This section doesn't exist")
            }

            switch section {
            case .patient:
                return self.createPatientSection()
            case .doctor:
                return self.createDoctorSection()
            }
        }

        return layout
    }

    private func createDoctorSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 25, leading: 10, bottom: 25, trailing: 10)
        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.45),
            heightDimension: .absolute(170)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous

        return layoutSection
    }

    private func createPatientSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1 / 6)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)

        return layoutSection
    }

//    private func createPatienFreeCell(for schedule: DoctorSchedule) {
//        let serviceDurationInMinutes = Int(schedule.serviceDuration / 60)
//        let scheduleInterval = Calendar.current.dateComponents(
//            [.hour, .minute],
//            from: schedule.startingTime,
//            to: schedule.endingTime
//        )
//
//        guard let scheduleHours = scheduleInterval.hour,
//              let scheduleMinutes = scheduleInterval.minute else { return }
//        let scheduleIntervalInMinutes = scheduleHours * 60 + scheduleMinutes
//        print(scheduleIntervalInMinutes)
//    }
}

extension TimeTableView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)

        if section == .doctor {
            output.didSelected(doctorAt: indexPath)
        }
    }
}

extension TimeTableView: TimeTableViewInput {
    func snapshot(ofSchedules schedules: [DoctorSchedule]) {
        guard let firstSchedule = schedules.first else { return }

        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.doctor, .patient])
        snapshot.appendItems(schedules, toSection: .doctor)
        snapshot.appendItems(firstSchedule.patientCells, toSection: .patient)
        dataSource?.apply(snapshot)
    }

    func updatePatientsSection(for indexPath: IndexPath) {
        guard let dataSource = dataSource,
              let doctor = dataSource.itemIdentifier(for: indexPath) as? DoctorSchedule else { return }

        var snapshot = dataSource.snapshot()
        snapshot.deleteSections([.patient])
        snapshot.appendSections([.patient])
        snapshot.appendItems(doctor.patientCells, toSection: .patient)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
