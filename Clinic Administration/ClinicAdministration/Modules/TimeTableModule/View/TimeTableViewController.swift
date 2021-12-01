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

    private var controlItem: [DoctorControl] = []

    private var doctorSectionPlaceHolder: [DoctorSectionPlaceholder] = []

    private var selectedSchedule: DoctorSchedule?

    private var datePicker: DatePicker!

    var newSchedule: DoctorSchedule?

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

        controlItem = [
            DoctorControl(target: self, addAction: #selector(addNewSchedule), deleteAction: #selector(deleteSchedule))
        ]

        doctorSectionPlaceHolder = [
            DoctorSectionPlaceholder(
                message: "НА ЭТОТ ДЕНЬ НЕТ РАСПИСАНИЙ ВРАЧЕЙ",
                buttonTitle: "СОЗДАТЬ РАСПИСАНИЕ",
                target: self,
                action: #selector(addNewSchedule)
            )
        ]

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.tintColor = Design.Color.chocolate

        presenter.didSelected(date: date)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        selectedSchedule = nil
        newSchedule = nil
    }

    @objc private func switchToGraphicScreen() {
        presenter.switchToGraphicScreen(onDate: date)
    }

    @objc private func addNewSchedule() {
        presenter.addNewDoctorSchedule(onDate: date)
    }

    @objc private func deleteSchedule() {
        guard let selectedSchedule = selectedSchedule else { return }

        let alert = AlertsFactory.makeRemoveSchedule(
            selectedSchedule,
            confirmAction: presenter.removeDoctorSchedule(_:)
        )

        present(alert, animated: true)
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
            let cell = factory.makeCell(with: item, for: indexPath)

            return cell
        }
    }

    private func createSupplementaryViews() {
        dataSource?.supplementaryViewProvider = { [datePicker] collectionView, kind, indexPath in
            if kind == ElementKind.patientSectionHeader,
               let patientSectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DatePickerHeader.reuseIdentifier,
                for: indexPath
            ) as? DatePickerHeader {
                guard let datePicker = datePicker else { return nil }

                patientSectionHeader.configure(with: datePicker)

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
                fatalError("Unknown section type.")
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
        guard let dataSource = dataSource else { return }

        if let doctorSchedule = dataSource.itemIdentifier(for: indexPath) as? DoctorSchedule {
            presenter.didSelected(doctorSchedule)

            collectionView.selectItem(
                at: indexPath,
                animated: true,
                scrollPosition: indexPath.row == 1 ? .left : .centeredHorizontally
            )
            selectedSchedule = doctorSchedule
        } else if let patientAppointment = dataSource.itemIdentifier(for: indexPath) as? PatientAppointment {
            guard let patient = patientAppointment.patient else {
                presenter.createPatientAppointment(schedule: selectedSchedule, selectedAppointment: patientAppointment)

                return
            }

            presenter.showPatientCard(patient)
        } else if let action = dataSource.itemIdentifier(for: indexPath) as? TimeTableAction,
                  let selectedSchedule = selectedSchedule {
            switch action {
            case .showNextSchedule:
                presenter.showDoctorsNextSchedule(after: selectedSchedule)
            case .showAllSchedules:
                presenter.showSchedulesList(for: selectedSchedule.doctor)
            default: ()
            }
        }
    }
}

// MARK: - TimeTableDisplaying

extension TimeTableViewController: TimeTableDisplaying {
    func daySnapshot(schedules: [DoctorSchedule], selectedSchedule: DoctorSchedule) {
        assert(
            !schedules.isEmpty,
            "'schedules' cannot be an empty array in this method. Use emptyDaySnapshot() instead."
        )

        collectionView.collectionViewLayout = createCompositionalLayout(withSchedules: true, count: schedules.count)
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.deleteSections([.doctor, .patient, .actionList])
        snapshot.appendSections([.doctor, .patient, .actionList])
        snapshot.appendItems(controlItem, toSection: .doctor)
        snapshot.appendItems(schedules, toSection: .doctor)
        snapshot.appendItems(selectedSchedule.patientAppointments, toSection: .patient)
        snapshot.appendItems(actionList, toSection: .actionList)
        dataSource?.apply(snapshot, animatingDifferences: false)
        collectionView.layoutIfNeeded()

        let indexPath = dataSource?.indexPath(for: selectedSchedule)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        self.selectedSchedule = selectedSchedule
    }

    func emptyDaySnapshot() {
        collectionView.collectionViewLayout = createCompositionalLayout(withSchedules: false)
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.deleteSections([.doctor, .patient, .actionList])
        snapshot.appendSections([.doctor, .patient])
        snapshot.appendItems(doctorSectionPlaceHolder, toSection: .doctor)
        snapshot.appendItems(
            (0...3).map { PatientAppointment(scheduledTime: nil, duration: Double($0), patient: nil) },
            toSection: .patient
        )
        dataSource?.apply(snapshot, animatingDifferences: false)
        collectionView.layoutIfNeeded()

        selectedSchedule = nil
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

    func changeDate(_ date: Date?) {
        datePicker.changeDate(date)
    }

    func noNextScheduleAlert() {
        guard let doctor = selectedSchedule?.doctor else { return }

        let alert = AlertsFactory.makeNoNextSchedule(for: doctor, createAction: presenter.createSchedule)

        present(alert, animated: true)
    }
}
