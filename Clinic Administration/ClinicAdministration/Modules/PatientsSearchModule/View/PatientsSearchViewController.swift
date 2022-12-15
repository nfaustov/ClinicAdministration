//
//  PatientsSearchViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 15.12.2022.
//

import UIKit

final class PatientsSearchViewController: SearchViewController<Patient> {
    typealias PresenterType = PatientsSearchPresentation
    var presenter: PresenterType!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Выберите пациента"

        view.backgroundColor = Design.Color.white
        searchBar.tintColor = Design.Color.darkGray

        searchBar.delegate = self
        searchCollectionView.delegate = self

        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.patientsRequest()
    }

    // MARK: - UICollectionViewDiffableDataSource

    private func configureDataSource() {
        searchCollectionView.register(PatientItemCell.self, forCellWithReuseIdentifier: PatientItemCell.reuseIdentifier)

        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: searchCollectionView
        ) { collectionView, indexPath, item in
            guard let patient = item as? Patient else { fatalError("Unknown model type") }

            let factory = CellFactory(collectionView: collectionView)
            let cell = factory.configureCell(PatientItemCell.self, with: patient, for: indexPath)

            return cell
        }
    }

    // MARK: - UICollectionViewLayout

    override func createResultSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 2
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        return layoutSection
    }
}

// MARK: - UICollectionViewDelegate

extension PatientsSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = dataSource,
              let patient = dataSource.itemIdentifier(for: indexPath) as? Patient else { return }

        presenter.didFinish(with: patient)
    }
}

// MARK: - UISearchBarDelegate

extension PatientsSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.performQuery(with: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        presenter.performQuery(with: "")
    }
}

// MARK: - PatientsSearchView

extension PatientsSearchViewController: PatientsSearchView {
    func patientsSnapshot(_ patients: [Patient]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.result])
        snapshot.appendItems(patients)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
