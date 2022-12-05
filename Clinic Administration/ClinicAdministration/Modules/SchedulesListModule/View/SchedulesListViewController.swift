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
    private var calendarControl: CalendarView!

    private var calendar = Calendar.current
    private var selectedDay: Day?

    var workingDays = [Date]()

    var doctor: Doctor!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = Design.Color.lightGray

        calendar.locale = Locale(identifier: "ru_RU")

        configureHierarchy()
        configureDataSource()

        calendarControl.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }

            if self.compareToNow(day) != .orderedAscending, day != self.selectedDay {
                self.selectedDay = day

                guard let components = self.selectedDay?.components,
                      let pickedDate = self.calendar.date(from: components) else { return }

                self.presenter.getSchedules(for: self.doctor, onDate: pickedDate)
            } else if day == self.selectedDay {
                self.selectedDay = nil
                self.presenter.getSchedules(for: self.doctor, onDate: nil)
            }

            let newContent = self.makeContent()
            self.calendarControl.setContent(newContent)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.getSchedules(for: doctor, onDate: nil)
        calendarControl.setContent(makeContent())
    }

    private func configureHierarchy() {
        view.backgroundColor = Design.Color.lightGray

        let calendarView = CalendarView(initialContent: makeContent())
        calendarView.backgroundColor = Design.Color.chocolate
        view.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false

        let schedulesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        schedulesCollectionView.backgroundColor = .clear
        view.addSubview(schedulesCollectionView)
        schedulesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        schedulesCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        schedulesCollectionView.delegate = self

        let views = ["schedulesCollectionView": schedulesCollectionView, "calendarControl": calendarView]
        var constraints = [NSLayoutConstraint]()
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[schedulesCollectionView]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[calendarControl]-[schedulesCollectionView]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        constraints.append(calendarView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.6))
        constraints.append(calendarView.widthAnchor.constraint(equalToConstant: view.frame.width))
        NSLayoutConstraint.activate(constraints)

        collectionView = schedulesCollectionView
        calendarControl = calendarView
    }

    // MARK: - CalendarViewContent

    private func makeContent() -> CalendarViewContent {
        CalendarViewContent(
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
                self.customizeDay(day)
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
            .withMonthDayInsets(.init(top: 0, left: 0, bottom: 12, right: 12))
            .withDaysOfTheWeekRowSeparator(options: .init(height: 1, color: Design.Color.darkGray))
            .withVerticalDayMargin(8)
            .withHorizontalDayMargin(8)
    }

    private func customizeDay(_ day: Day) -> CalendarItemModel<CalendarControlDayLabel> {
        let workingDaysComponents = workingDays.map { calendar.dateComponents([.era, .year, .month, .day], from: $0) }

        var invariantViewProperties = CalendarControlDayLabel.InvariantViewProperties(
            font: Design.Font.robotoFont(ofSize: 18, weight: .regular),
            textColor: Design.Color.gray,
            backgroundColor: .clear,
            borderColor: .clear
        )

        // customize marked working days
        workingDaysComponents.forEach { components in
            if day.components == components {
                invariantViewProperties.borderColor = Design.Color.darkGray
            }
        }
        // customize selected day
        if day == selectedDay {
            invariantViewProperties.textColor = Design.Color.brown
            invariantViewProperties.backgroundColor = Design.Color.lightGray
        }

        // customize past days
        if compareToNow(day) == .orderedAscending {
            invariantViewProperties.textColor = Design.Color.darkGray
        }

        return CalendarItemModel<CalendarControlDayLabel>(
            invariantViewProperties: invariantViewProperties,
            viewModel: .init(day: day)
        )
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

// MARK: - SchedulesListView

extension SchedulesListViewController: SchedulesListView {
    func schedulesSnapshot(_ schedules: [DoctorSchedule]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DoctorSchedule>()
        snapshot.appendSections([.main])
        snapshot.appendItems(schedules)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
