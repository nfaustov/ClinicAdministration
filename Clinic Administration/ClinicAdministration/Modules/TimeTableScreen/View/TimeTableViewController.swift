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
        static let patientSectionBackground = "patient-section-background"
        static let doctorSectionHeader = "doctor-section-header"
        static let actionListFooter = "action-list-footer"
        static let actionListBackground = "action-list-background"
        static let doctorPlaceholder = "doctor-placeholder"
    }

    private enum Section: Int, Hashable {
        case doctor
        case patient
        case actionList
    }

    private var collectionView: UICollectionView!

    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?

    private var actionList: [TimeTableAction] = [.showNextSchedule, .showAllSchedules, .editSchedule]

    var presenter: TimeTablePresentation!

    var date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        let switchToGraphicImage = UIImage(named: "dashboard")
        let rightBarButton = UIBarButtonItem(
            image: switchToGraphicImage,
            style: .plain,
            target: self,
            action: #selector(switchToGraphicScreen)
        )
        navigationItem.rightBarButtonItem = rightBarButton

        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createCompositionalLayout(withSchedules: true)
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = Design.Color.lightGray
        collectionView.delegate = self
        view.addSubview(collectionView)

        registerViews()
        createDataSource()
        createSupplementaryViews()

        presenter.didSelected(date: date)
    }

    @objc private func switchToGraphicScreen() {
        presenter.switchToGraphicScreen(onDate: date)
    }

    private func registerViews() {
        collectionView.register(DoctorCell.self, forCellWithReuseIdentifier: DoctorCell.reuseIdentifier)
        collectionView.register(PatientCell.self, forCellWithReuseIdentifier: PatientCell.reuseIdentifier)
        collectionView.register(ActionListCell.self, forCellWithReuseIdentifier: ActionListCell.reuseIdentifier)
        collectionView.register(DoctorPlaceholder.self, forCellWithReuseIdentifier: DoctorPlaceholder.reuseIdentifier)
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
            forSupplementaryViewOfKind: ElementKind.actionListFooter,
            withReuseIdentifier: CallButtonFooter.reuseIdentifier
        )
    }

    // MARK: - UICollectionViewDiffableDataSource

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            let factory = TimeTableCellFactory(collectionView: collectionView)
            let cell = factory.getCell(with: item, for: indexPath)

            return cell
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
            } else if kind == ElementKind.actionListFooter,
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

    private func createCompositionalLayout(withSchedules: Bool) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("This section doesn't exist")
            }

            let timeTableLayout = TimeTableCollectionViewLayout(
                patientSectionHeaderElementKind: ElementKind.patientSectionHeader,
                actionListFooterElementKind: ElementKind.actionListFooter,
                patientSectionBackgroundElementKind: ElementKind.patientSectionBackground,
                doctorSectionHeaderElementKind: ElementKind.doctorSectionHeader,
                actionListBackgroundElementKind: ElementKind.actionListBackground
            )

            switch section {
            case .doctor:
                return withSchedules ? timeTableLayout.createDoctorSection() : timeTableLayout.createDoctorPlaceholder()
            case .patient:
                return timeTableLayout.createPatientSection()
            case .actionList:
                return timeTableLayout.createActionListSection()
            }
        }

        layout.register(
            PatientSectionBackgroundDecorationView.self,
            forDecorationViewOfKind: ElementKind.patientSectionBackground
        )
        layout.register(
            ActionListBackgroundDecorationView.self,
            forDecorationViewOfKind: ElementKind.actionListBackground
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
    func daySnapshot(schedules: [DoctorSchedule]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()

        if let firstSchedule = schedules.first {
            collectionView.collectionViewLayout = createCompositionalLayout(withSchedules: true)
            snapshot.deleteSections([.doctor, .patient, .actionList])
            snapshot.appendSections([.doctor, .patient, .actionList])
            snapshot.appendItems(schedules, toSection: .doctor)
            snapshot.appendItems(firstSchedule.patientCells, toSection: .patient)
            snapshot.appendItems(actionList, toSection: .actionList)
            dataSource?.apply(snapshot)

            let indexPath = dataSource?.indexPath(for: firstSchedule)
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        } else {
            collectionView.collectionViewLayout = createCompositionalLayout(withSchedules: false)
            snapshot.deleteSections([.doctor, .patient, .actionList])
            snapshot.appendSections([.doctor, .patient])
            snapshot.appendItems([DoctorSectionPlaceholder.addFirstSchedule], toSection: .doctor)
            snapshot.appendItems(
                [
                    TimeTablePatientCell(scheduledTime: nil, duration: 0, patient: nil),
                    TimeTablePatientCell(scheduledTime: nil, duration: 1, patient: nil),
                    TimeTablePatientCell(scheduledTime: nil, duration: 2, patient: nil),
                    TimeTablePatientCell(scheduledTime: nil, duration: 3, patient: nil)
                ],
                toSection: .patient
            )
            dataSource?.apply(snapshot)
        }
    }

    func doctorSnapshot(schedule: DoctorSchedule) {
        guard let dataSource = dataSource else { return }

        var snapshot = dataSource.snapshot()
        snapshot.deleteSections([.patient, .actionList])
        snapshot.appendSections([.patient, .actionList])
        snapshot.appendItems(schedule.patientCells, toSection: .patient)
        snapshot.appendItems(actionList, toSection: .actionList)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
