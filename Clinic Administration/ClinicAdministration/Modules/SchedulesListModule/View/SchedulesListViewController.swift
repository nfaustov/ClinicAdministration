//
//  SchedulesListViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.10.2021.
//

import UIKit
import HorizonCalendar

final class SchedulesListViewController: UIViewController {
    typealias PresenterType = SchedulesListPresentation
    var presenter: PresenterType!

    private enum Section {
        case main
    }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, DoctorSchedule>!

    private var calendar = Calendar.current
    private var selectedDay: Day?

    var doctor: Doctor!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = Design.Color.lightGray

        calendar.locale = Locale(identifier: "ru_RU")

        configureHierarchy()
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.getSchedules(for: doctor)
    }

    private func configureHierarchy() {
        view.backgroundColor = Design.Color.lightGray

        let calendarView = CalendarView(initialContent: makeContent())
        calendarView.backgroundColor = Design.Color.chocolate
        view.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false

        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }

            if self.compareToNow(day) != .orderedAscending {
                self.selectedDay = day

                guard let components = self.selectedDay?.components,
                      let pickedDate = self.calendar.date(from: components) else { return }

                self.presenter.getSchedules(for: self.doctor, for: pickedDate)
            }

            let newContent = self.makeContent()
            calendarView.setContent(newContent)
        }

        let schedulesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        schedulesCollectionView.backgroundColor = .clear
        view.addSubview(schedulesCollectionView)
        schedulesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        schedulesCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        schedulesCollectionView.delegate = self

        let views = ["cv": schedulesCollectionView, "calendarControl": calendarView]
        var constraints = [NSLayoutConstraint]()
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[cv]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[calendarControl]-[cv]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        constraints.append(calendarView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.6))
        constraints.append(calendarView.widthAnchor.constraint(equalToConstant: view.frame.width))
        NSLayoutConstraint.activate(constraints)

        collectionView = schedulesCollectionView
    }

    // MARK: - CalendarViewContent

    private func makeContent() -> CalendarViewContent {
        let selectedDay = self.selectedDay

        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: Date()...Date(timeInterval: 60 * 60 * 24 * 365, since: Date()),
            monthsLayout: .horizontal(
                options: HorizontalMonthsLayoutOptions(
                    maximumFullyVisibleMonths: 1,
                    scrollingBehavior: .paginatedScrolling(
                        .init(
                            restingPosition: .atLeadingEdgeOfEachMonth,
                            restingAffinity: .atPositionsAdjacentToPrevious
                        )
                    )
                )
            )
        )
            .withDayItemModelProvider { day in
                var invariantViewProperties = CalendarControlDayLabel.InvariantViewProperties(
                    font: Design.Font.robotoFont(ofSize: 18, weight: .regular),
                    textColor: Design.Color.gray,
                    backgroundColor: .clear
                )

                if day == selectedDay {
                    invariantViewProperties.textColor = Design.Color.brown
                    invariantViewProperties.backgroundColor = Design.Color.lightGray
                }

                if self.compareToNow(day) == .orderedAscending {
                    invariantViewProperties.textColor = Design.Color.darkGray
                }

                return CalendarItemModel<CalendarControlDayLabel>(
                    invariantViewProperties: invariantViewProperties,
                    viewModel: .init(day: day)
                )
            }
            .withMonthHeaderItemModelProvider { month in
                CalendarItemModel<CalendarControlMonthHeader>(
                    invariantViewProperties: .init(
                        font: Design.Font.robotoFont(ofSize: 22, weight: .medium),
                        textColor: Design.Color.lightGray,
                        backgroundColor: .clear
                    ),
                    viewModel: .init(month: month)
                )
            }
            .withDayOfWeekItemModelProvider { _, dayOfWeekIndex in
                CalendarItemModel<CalendarControlDayOfWeekRow>(
                    invariantViewProperties: .init(
                        font: Design.Font.robotoFont(ofSize: 16, weight: .regular),
                        textColor: Design.Color.darkGray,
                        backgroundColor: .clear
                    ),
                    viewModel: .init(dayOfWeekIndex: dayOfWeekIndex)
                )
            }
            .withVerticalDayMargin(6)
            .withHorizontalDayMargin(6)
    }

    private func compareToNow(_ day: Day) -> ComparisonResult? {
        guard let calendarDay = Calendar.current.date(from: day.components) else { return nil }

        let result = Calendar.current.compare(calendarDay, to: Date(), toGranularity: .day)

        return result
    }

    // MARK: - UICollectionViewLayout

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
            )
            let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [layoutItem])
            let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 30, trailing: 20)
            layoutSection.interGroupSpacing = 1

            return layoutSection
        }

        return layout
    }

    // MARK: - UICollectionViewDataSource

    private func configureDataSource() {
        collectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: ScheduleCell.reuseIdentifier)

        dataSource = UICollectionViewDiffableDataSource<Section, DoctorSchedule>(
            collectionView: collectionView
        ) { collectionView, indexPath, schedule in
            let factory = CellFactory(collectionView: collectionView)
            let cell = factory.configureCell(ScheduleCell.self, with: schedule, for: indexPath)

            switch indexPath.item {
            case 0:
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case indexPath.count - 1:
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            default: cell.layer.maskedCorners = []
            }

            cell.layer.cornerRadius = Design.CornerRadius.medium

            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension SchedulesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = dataSource,
              let schedule = dataSource.itemIdentifier(for: indexPath) else { return }

        presenter.didFinish(with: schedule)
    }
}

// MARK: - SchedulesListDisplaying

extension SchedulesListViewController: SchedulesListDisplaying {
    func schedulesSnapshot(_ schedules: [DoctorSchedule]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DoctorSchedule>()
        snapshot.appendSections([.main])
        snapshot.appendItems(schedules)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func dateSnapshot(_ schedules: [DoctorSchedule]) {
    }

    func dateRangeSnapshot(_ schedules: [DoctorSchedule]) {
    }
}
