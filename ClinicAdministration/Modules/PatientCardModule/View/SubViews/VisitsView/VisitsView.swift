//
//  VisitsView.swift
//  ClinicAdministration
//
//  Created by Николай Фаустов on 04.02.2023.
//

import UIKit

final class VisitsView: UIView {
    enum Section: Int {
        case main
    }

    private var visitsCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!

    init(visits: [Visit]) {
        super.init(frame: .zero)

        configureHierarchy()
        configureDataSource()
        visitsSnapshot(visits)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        layer.cornerRadius = Design.CornerRadius.large
        layer.masksToBounds = true

        visitsCollectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayout())
        visitsCollectionView.backgroundColor = Color.secondaryBackground
        addSubview(visitsCollectionView)
        visitsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        visitsCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
                heightDimension: .absolute(100)
            )
            let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [layoutItem])
            let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            layoutSection.interGroupSpacing = 20

            return layoutSection
        }

        return layout
    }

    private func configureDataSource() {
        visitsCollectionView.register(VisitCell.self, forCellWithReuseIdentifier: VisitCell.reuseIdentifier)

        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: visitsCollectionView
        ) { collectionView, indexPath, item in
            guard let visit = item as? Visit else { fatalError("Unknown model type") }

            let factory = CellFactory(collectionView: collectionView)
            let cell = factory.configureCell(VisitCell.self, with: visit, for: indexPath)

            return cell
        }
    }

    private func visitsSnapshot(_ visits: [Visit]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.main])
        snapshot.appendItems(visits, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: Public

    func setVisits(_ visits: [Visit]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteSections([.main])
        visitsSnapshot(visits)
    }
}

// MARK: - UICollectionViewDelegate

extension VisitsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
