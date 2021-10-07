//
//  CreateScheduleViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import UIKit

final class CreateScheduleViewController: UIViewController {
    typealias PresenterType = CreateSchedulePresentation
    var presenter: PresenterType!

    private enum Section: Int {
        case doctor
        case options
        case intervals
    }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!

    private var options: [ScheduleOption] {
        [
            ScheduleOption(
                title: "Дата",
                placeholder: "",
                icon: UIImage(named: "calendar"),
                date: date
            ),
            ScheduleOption(
                title: "Кабинет",
                placeholder: "\(currentDoctor?.defaultCabinet ?? 1) (по умолчанию)",
                icon: UIImage(named: "chevron_down"),
                date: nil
            )
        ]
    }

    var date = Date()
    var currentDoctor: Doctor?
    var intervals: [ScheduleInterval] = [.defaultInterval]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Расписание врача"

        configureHierarchy()
        registerViews()
        configureDataSource()
        initialSnapshot()
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = Design.Color.lightGray
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    private func registerViews() {
        collectionView.register(DoctorViewCell.self, forCellWithReuseIdentifier: DoctorViewCell.reuseIndentifier)
        collectionView.register(OptionCell.self, forCellWithReuseIdentifier: OptionCell.reuseIndentifier)
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            let factory = CreateScheduleCellFactory(collectionView: collectionView)
            let cell = factory.getCell(with: item, for: indexPath)

            return cell
        }
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section type.")
            }

            let createScheduleLayout = CreateScheduleCollectionViewLayout()

            switch section {
            case .doctor: return createScheduleLayout.createDoctorSection()
            case .options: return createScheduleLayout.createOptionsSection()
            case .intervals: return createScheduleLayout.createIntervalsSection()
            }
        }

        return layout
    }

    @objc private func addDoctorSchedule() {
//        guard let cabinet = schedulePicker.cabinet,
//              let interval = schedulePicker.interval else { return }

//        let schedule = DoctorSchedule(
//            id: UUID(),
//            secondName: doctor.secondName,
//            firstName: doctor.firstName,
//            patronymicName: doctor.patronymicName,
//            phoneNumber: doctor.phoneNumber,
//            specialization: doctor.specialization,
//            cabinet: cabinet,
//            startingTime: interval.0,
//            endingTime: interval.1,
//            serviceDuration: doctor.serviceDuration
//        )

//        presenter.addSchedule(schedule)
    }

    private func initialSnapshot() {
        guard let currentDoctor = currentDoctor else { return }

        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.doctor, .options, .intervals])
        snapshot.appendItems([currentDoctor], toSection: .doctor)
        snapshot.appendItems(options, toSection: .options)
        snapshot.appendItems(intervals, toSection: .intervals)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate

extension CreateScheduleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - CreateScheduleDisplaying

extension CreateScheduleViewController: CreateScheduleDisplaying {
    func pickedDoctor(_ doctor: Doctor) {
    }

    func pickedInterval(_ interval: (Date, Date)) {
    }

    func pickedCabinet(_ cabinet: Int) {
    }
}
