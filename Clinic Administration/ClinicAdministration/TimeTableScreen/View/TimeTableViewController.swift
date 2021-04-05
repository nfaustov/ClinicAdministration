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
    private enum ElementKind {
        static let patientSectionHeader = "patient-section-header"
        static let patientSectionFooter = "patient-section-footer"
        static let patientSectionBackground = "patient-section-background"
        static let doctorSectionHeader = "doctor-section-header"
    }

    private enum Section: Int, Hashable {
        case doctor
        case patient
    }

    private var collectionView: UICollectionView!

    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?

    var presenter: TimeTablePresentation!

    var date = Date().addingTimeInterval(86_400)

    override func viewDidLoad() {
        super.viewDidLoad()

        let switchToGraphicImage = UIImage(systemName: "squareshape.fill")
        let rightBarButton = UIBarButtonItem(
            image: switchToGraphicImage,
            style: .plain,
            target: self,
            action: #selector(switchToGraphicScreen)
        )
        navigationItem.rightBarButtonItem = rightBarButton

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = Design.Color.lightGray
        collectionView.delegate = self
        view.addSubview(collectionView)

        registerViews()
        createDataSource()
        createSupplementaryViews()

        presenter.viewDidLoad(with: date)
    }

    @objc private func switchToGraphicScreen() {
        presenter.switchToGraphicScreen(with: date)
    }

    private func registerViews() {
        collectionView.register(DoctorCell.self, forCellWithReuseIdentifier: DoctorCell.reuseIdentifier)
        collectionView.register(PatientCell.self, forCellWithReuseIdentifier: PatientCell.reuseIdentifier)
        collectionView.register(
            DoctorLeadingHeader.self,
            forSupplementaryViewOfKind: ElementKind.doctorSectionHeader,
            withReuseIdentifier: DoctorLeadingHeader.reuseIdentifier
        )
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
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }

            if kind == ElementKind.patientSectionHeader,
               let patientSectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DatePickerHeader.reuseIdentifier,
                for: indexPath
            ) as? DatePickerHeader {
                patientSectionHeader.configure(with: self.date, presenter: self.presenter)

                return patientSectionHeader
            } else if kind == ElementKind.patientSectionFooter,
                      let patientSectionFooter = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CallButtonFooter.reuseIdentifier,
                for: indexPath
            ) as? CallButtonFooter {
                return patientSectionFooter
            } else if kind == ElementKind.doctorSectionHeader,
                      let doctorSectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DoctorLeadingHeader.reuseIdentifier,
                for: indexPath
            ) as? DoctorLeadingHeader {
                return doctorSectionHeader
            } else { return nil }
        }
    }

    // MARK: - UICollectionViewLayout

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("This section doesn't exist")
            }

            let timeTableLayout = TimeTableCollectionViewLayout(
                patientSectionHeaderElementKind: ElementKind.patientSectionHeader,
                patientSectionFooterElementKind: ElementKind.patientSectionFooter,
                patientSectionBackgroundElementKind: ElementKind.patientSectionBackground,
                doctorSectionHeaderElementKind: ElementKind.doctorSectionHeader
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
        guard let dataSource = dataSource,
              let doctorSchedule = dataSource.itemIdentifier(for: indexPath) as? DoctorSchedule else { return }

        presenter.didSelected(doctorSchedule)

        collectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: indexPath.row == 0 ? .left : .centeredHorizontally
        )
    }
}

// MARK: - TimeTableDisplaying

extension TimeTableViewController: TimeTableDisplaying {
    func applyInitialSnapshot(ofSchedules schedules: [DoctorSchedule]) {
        guard let firstSchedule = schedules.first else { return }

        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.doctor, .patient])
        snapshot.appendItems(schedules, toSection: .doctor)
        snapshot.appendItems(firstSchedule.patientCells, toSection: .patient)
        dataSource?.apply(snapshot)

        let indexPath = dataSource?.indexPath(for: firstSchedule)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }

    func updatePatientsSection(for schedule: DoctorSchedule) {
        guard let dataSource = dataSource else { return }

        var snapshot = dataSource.snapshot()
        snapshot.deleteSections([.patient])
        snapshot.appendSections([.patient])
        snapshot.appendItems(schedule.patientCells, toSection: .patient)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
