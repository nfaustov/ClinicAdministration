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
                placeholder: selectedCabinet == currentDoctor?.defaultCabinet ?
                "\(selectedCabinet) (по умолчанию)" : "\(selectedCabinet)",
                icon: UIImage(named: "chevron_down"),
                date: nil
            )
        ]
    }

    var date = Date()
    var currentDoctor: Doctor?
    private var intervals: [DateInterval] = []
    private var selectedCabinet = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = Color.label
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Расписание врача"

        if let cabinet = currentDoctor?.defaultCabinet {
            selectedCabinet = cabinet
        }

        configureHierarchy()
        registerViews()
        configureDataSource()
        configureSupplementaryViews()

        presenter.makeIntervals(onDate: date, forCabinet: selectedCabinet)
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = Color.background
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    private func registerViews() {
        collectionView.register(DoctorViewCell.self, forCellWithReuseIdentifier: DoctorViewCell.reuseIdentifier)
        collectionView.register(OptionCell.self, forCellWithReuseIdentifier: OptionCell.reuseIdentifier)
        collectionView.register(IntervalCell.self, forCellWithReuseIdentifier: IntervalCell.reuseIdentifier)
        collectionView.register(
            IntervalsHeader.self,
            forSupplementaryViewOfKind: "intervals-header",
            withReuseIdentifier: IntervalsHeader.reuseIdentifier
        )
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            let factory = CreateScheduleCellFactory(collectionView: collectionView)
            let cell = factory.makeCell(with: item, for: indexPath)

            return cell
        }
    }

    private func configureSupplementaryViews() {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let intervalsHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: IntervalsHeader.reuseIdentifier,
                for: indexPath
            ) as? IntervalsHeader else { return nil }

            intervalsHeader.configure()

            return intervalsHeader
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
        if let option = dataSource?.itemIdentifier(for: indexPath) as? ScheduleOption {
            switch option.title {
            case "Дата":
                presenter.pickDateInCalendar()
            case "Кабинет":
                presenter.pickCabinet(selected: selectedCabinet)
            default: break
            }
        } else if let interval = dataSource.itemIdentifier(for: indexPath) as? DateInterval {
            guard let doctor = currentDoctor else { return }

            let doctorSchedule = DoctorSchedule(
                doctor: doctor,
                starting: interval.start,
                ending: interval.start.addingTimeInterval(doctor.serviceDuration),
                cabinet: selectedCabinet
            )
            presenter.schedulePreview(doctorSchedule)
        }
    }
}

// MARK: - CreateScheduleView

extension CreateScheduleViewController: CreateScheduleView {
    func createdIntervals(_ intervals: [DateInterval]) {
        self.intervals = intervals
        initialSnapshot()
    }

    func pickedCabinet(_ cabinet: Int) {
        selectedCabinet = cabinet
        presenter.makeIntervals(onDate: date, forCabinet: selectedCabinet)
        initialSnapshot()
    }

    func pickedDate(_ date: Date) {
        self.date = date
        presenter.makeIntervals(onDate: date, forCabinet: selectedCabinet)
        initialSnapshot()
    }
}
