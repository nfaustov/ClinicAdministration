//
//  SchedulesListViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.10.2021.
//

import UIKit

final class SchedulesListViewController: UIViewController {
    typealias PresenterType = SchedulesListPresentation
    var presenter: PresenterType!

    private enum Section {
        case main
    }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, DoctorSchedule>!

    var doctor: Doctor!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.getSchedules(for: doctor)
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = Design.Color.lightGray
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
    }

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
}
