//
//  TimeTableViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import UIKit

final class TimeTableViewController: UIViewController {
    typealias PresenterType = TimeTablePresentation
    var presenter: PresenterType!

    private enum ElementKind {
        static let patientSectionHeader = "patient-section-header"
        static let patientSectionBackground = "patient-section-background"
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

    private lazy var controlItem: [DoctorControl] = [
        DoctorControl(
            target: self,
            addAction: #selector(addNewSchedule),
            deleteAction: #selector(deleteSchedule)
        )
    ]

    private var selectedSchedule: DoctorSchedule?

    private var datePicker: DatePicker!

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

        datePicker = DatePicker(
            selectedDate: date,
            dateAction: presenter.didSelected,
            calendarAction: presenter.pickDateInCalendar
        )

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

    @objc private func addNewSchedule() {
        presenter.addNewDoctorSchedule(onDate: date)
    }

    @objc private func deleteSchedule() {
        guard let selectedSchedule = selectedSchedule else { return }

        presenter.removeDoctorSchedule(selectedSchedule)
    }

    private func registerViews() {
        collectionView.register(DoctorCell.self, forCellWithReuseIdentifier: DoctorCell.reuseIdentifier)
        collectionView.register(PatientCell.self, forCellWithReuseIdentifier: PatientCell.reuseIdentifier)
        collectionView.register(ActionListCell.self, forCellWithReuseIdentifier: ActionListCell.reuseIdentifier)
        collectionView.register(DoctorPlaceholder.self, forCellWithReuseIdentifier: DoctorPlaceholder.reuseIdentifier)
        collectionView.register(DoctorControlCell.self, forCellWithReuseIdentifier: DoctorControlCell.reuseIdentifier)
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
                patientSectionHeader.configure(with: self.date, datePicker: self.datePicker)

                return patientSectionHeader
            } else if kind == ElementKind.actionListFooter,
                let actionListFooter = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CallButtonFooter.reuseIdentifier,
                for: indexPath
            ) as? CallButtonFooter {
                return actionListFooter
            } else { return nil }
        }
    }

    // MARK: - UICollectionViewLayout

    private func createCompositionalLayout(withSchedules: Bool, count: Int = 0) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("This section doesn't exist")
            }

            let timeTableLayout = TimeTableCollectionViewLayout(
                patientSectionHeaderElementKind: ElementKind.patientSectionHeader,
                actionListFooterElementKind: ElementKind.actionListFooter,
                patientSectionBackgroundElementKind: ElementKind.patientSectionBackground,
                actionListBackgroundElementKind: ElementKind.actionListBackground
            )

            switch section {
            case .doctor:
                return withSchedules ?
                    timeTableLayout.createDoctorSection(count: count) :
                    timeTableLayout.createDoctorPlaceholder()
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
            scrollPosition: indexPath.row == 1 ? .left : .centeredHorizontally
        )
        selectedSchedule = doctorSchedule
    }
}

// MARK: - TimeTableDisplaying

extension TimeTableViewController: TimeTableDisplaying {
    func daySnapshot(schedules: [DoctorSchedule]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()

        if let firstSchedule = schedules.first {
            collectionView.collectionViewLayout = createCompositionalLayout(withSchedules: true, count: schedules.count)
            snapshot.deleteSections([.doctor, .patient, .actionList])
            snapshot.appendSections([.doctor, .patient, .actionList])
            snapshot.appendItems(controlItem, toSection: .doctor)
            snapshot.appendItems(schedules, toSection: .doctor)
            snapshot.appendItems(firstSchedule.patientAppointments, toSection: .patient)
            snapshot.appendItems(actionList, toSection: .actionList)
            dataSource?.apply(snapshot, animatingDifferences: false)

            let indexPath = dataSource?.indexPath(for: firstSchedule)
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            selectedSchedule = firstSchedule
        } else {
            collectionView.collectionViewLayout = createCompositionalLayout(withSchedules: false)
            snapshot.deleteSections([.doctor, .patient, .actionList])
            snapshot.appendSections([.doctor, .patient])
            snapshot.appendItems([DoctorSectionPlaceholder.addFirstSchedule], toSection: .doctor)
            snapshot.appendItems(
                [
                    PatientAppointment(scheduledTime: nil, duration: 0, patient: nil),
                    PatientAppointment(scheduledTime: nil, duration: 1, patient: nil),
                    PatientAppointment(scheduledTime: nil, duration: 2, patient: nil),
                    PatientAppointment(scheduledTime: nil, duration: 3, patient: nil)
                ],
                toSection: .patient
            )
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }

    func doctorSnapshot(schedule: DoctorSchedule) {
        guard let dataSource = dataSource else { return }

        var snapshot = dataSource.snapshot()
        snapshot.deleteSections([.patient, .actionList])
        snapshot.appendSections([.patient, .actionList])
        snapshot.appendItems(schedule.patientAppointments, toSection: .patient)
        snapshot.appendItems(actionList, toSection: .actionList)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func sidePicked(date: Date?) {
        datePicker.sidePicked(date: date)
    }
}
