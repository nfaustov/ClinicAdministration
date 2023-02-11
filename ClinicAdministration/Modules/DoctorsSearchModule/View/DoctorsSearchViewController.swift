//
//  DoctorsSearchViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 03.06.2021.
//

import UIKit

final class DoctorsSearchViewController: SearchViewController<Doctor> {
    typealias PresenterType = DoctorsSearchPresentation
    var presenter: PresenterType!

    private var selectedSpecialization: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Выберите врача"

        view.backgroundColor = Color.secondaryBackground
        searchBar.tintColor = Color.tertiaryLabel

        searchBar.delegate = self
        searchCollectionView.delegate = self

        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.doctorsRequest()
    }

    // MARK: - UICollectionViewDiffableDataSource

    private func configureDataSource() {
        searchCollectionView.register(DoctorItemCell.self, forCellWithReuseIdentifier: DoctorItemCell.reuseIdentifier)
        searchCollectionView.register(
            SpecializationCell.self,
            forCellWithReuseIdentifier: SpecializationCell.reuseIdentifier
        )

        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: searchCollectionView
        ) { collectionView, indexPath, item in
            let factory = DoctorsSearchCellFactory(collectionView: collectionView)
            let cell = factory.makeCell(with: item, for: indexPath)

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
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(60)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: layoutItem, count: 2)
        layoutGroup.interItemSpacing = .fixed(10)
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 20
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        return layoutSection
    }

    override func createFilterSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(50)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutGroupSize,
            subitems: [layoutItem]
        )
        layoutGroup.interItemSpacing = .fixed(10)
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous

        return layoutSection
    }
}

// MARK: - UICollectionViewDelegate

extension DoctorsSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }

        if let doctor = dataSource.itemIdentifier(for: indexPath) as? Doctor {
            presenter.didFinish(with: doctor)
        } else if let specialization = dataSource.itemIdentifier(for: indexPath) as? String {
            if specialization == selectedSpecialization {
                searchCollectionView.deselectItem(at: indexPath, animated: false)
                selectedSpecialization = nil
            } else {
                selectedSpecialization = specialization
            }

            presenter.performQuery(with: searchBar.text ?? "", specialization: selectedSpecialization)
        }
    }
}

// MARK: - UISearchBarDelegate

extension DoctorsSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.performQuery(with: searchText, specialization: selectedSpecialization)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        selectedSpecialization = nil
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        presenter.performQuery(with: "", specialization: selectedSpecialization)
    }
}

// MARK: - DoctorsSearchView

extension DoctorsSearchViewController: DoctorsSearchView {
    func doctorsSnapshot(_ doctors: [Doctor]) {
        let specializations = Array(Set(doctors.map { $0.specialization }))

        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.filter, .result])
        snapshot.appendItems(specializations, toSection: .filter)
        snapshot.appendItems(doctors, toSection: .result)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
