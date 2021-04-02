//
//  TimeTableViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import UIKit
import Extensions
import Design
import DatePicker

final class TimeTableViewController: UIViewController {
    private struct ElementKind {
        static let patientSectionHeader = "patient-section-header"
        static let patientSectionFooter = "patient-section-footer"
        static let patientSectionBackground = "patient-section-background"
    }

    private enum Section: Int, Hashable {
        case doctor
        case patient
    }

    private var collectionView: UICollectionView!

    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?

    var output: TimeTableViewOutput!

    var date = Date().addingTimeInterval(172_800)

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = Design.Color.lightGray
        collectionView.delegate = self
        view.addSubview(collectionView)

        collectionView.register(DoctorCell.self, forCellWithReuseIdentifier: DoctorCell.reuseIdentifier)
        collectionView.register(PatientCell.self, forCellWithReuseIdentifier: PatientCell.reuseIdentifier)
        collectionView.register(
            DatePickerHeader.self,
            forSupplementaryViewOfKind: ElementKind.patientSectionHeader,
            withReuseIdentifier: DatePickerHeader.reuseIdentifier
        )
        collectionView.register(
            CallButtonFooter.self,
            forSupplementaryViewOfKind: ElementKind.patientSectionFooter,
            withReuseIdentifier: CallButtonFooter.reuseIdentifier
        )

        createDataSource()
        createSupplementaryViews()

        output.viewDidLoad(with: date)
    }

    private func addDatePicker(toView superView: UIView) {
        let datePicker = DatePicker(
            selectedDate: date,
            dateAction: output.didSelected(date:),
            calendarAction: output.calendarRequired
        )

        superView.addSubview(datePicker)

        datePicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: superView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 12),
            datePicker.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -12),
            datePicker.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    private func addCallButton(toView superView: UIView) {
        let button = UIButton()
        button.setTitle("СВЯЗАТЬСЯ С ВРАЧОМ", for: .normal)
        button.setTitleColor(Design.Color.white, for: .normal)
        button.backgroundColor = Design.Color.red
        button.layer.cornerRadius = Design.CornerRadius.medium
        button.titleEdgeInsets.left = -70
        superView.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - UICollectionViewDiffableDataSource

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

    private func createSupplementaryViews() {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: ElementKind.patientSectionHeader,
                withReuseIdentifier: DatePickerHeader.reuseIdentifier,
                for: indexPath
            ) as? DatePickerHeader,
            kind == ElementKind.patientSectionHeader {
                self.addDatePicker(toView: sectionHeader)

                return sectionHeader
            } else if let sectionFooter = collectionView.dequeueReusableSupplementaryView(
                ofKind: ElementKind.patientSectionFooter,
                withReuseIdentifier: CallButtonFooter.reuseIdentifier,
                for: indexPath
            ) as? CallButtonFooter,
            kind == ElementKind.patientSectionFooter {
                self.addCallButton(toView: sectionFooter)

                return sectionFooter
            } else { return nil }
        }
    }

    // MARK: - UICollectionViewLayout

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("This section doesn't exist")
            }

            let timeTableLayout = TimeTableLayout(
                patientSectionHeaderElementKind: ElementKind.patientSectionHeader,
                patientSectionFooterElementKind: ElementKind.patientSectionFooter,
                patientSectionBackgroundElementKind: ElementKind.patientSectionBackground
            )

            switch section {
            case .patient:
                return timeTableLayout.createPatientSection()
            case .doctor:
                return timeTableLayout.createDoctorSection()
            }
        }

        layout.register(
            PatientSectionBackgroundDecorationView.self,
            forDecorationViewOfKind: ElementKind.patientSectionBackground
        )

        return layout
    }
}

// MARK: - UICollectionViewDelegate

extension TimeTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)

        if section == .doctor {
            output.didSelected(doctorAt: indexPath)
        }
    }
}

// MARK: - TimeTableInput

extension TimeTableViewController: TimeTableViewInput {
    func applyInitialSnapshot(ofSchedules schedules: [DoctorSchedule]) {
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
