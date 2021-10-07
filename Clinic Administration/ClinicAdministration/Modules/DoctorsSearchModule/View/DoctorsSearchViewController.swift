//
//  DoctorsSearchViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 03.06.2021.
//

import UIKit

final class DoctorsSearchViewController: UIViewController {
    typealias PresenterType = DoctorsSearchPresentation
    var presenter: PresenterType!

    private enum Section {
        case main
    }

    private var searchBar = UISearchBar()

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Doctor>!

    var doctorsList = [Doctor]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Выберите врача"

        configureHierarchy()
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.doctorsRequest()
    }

    func configureHierarchy() {
        view.backgroundColor = Design.Color.white
        let doctorsCollectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout()
        )
        doctorsCollectionView.backgroundColor = Design.Color.white
        view.addSubview(doctorsCollectionView)
        doctorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        doctorsCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        doctorsCollectionView.delegate = self

        searchBar.backgroundColor = Design.Color.white
        searchBar.placeholder = "Поиск"
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self

        let views = ["collectionView": doctorsCollectionView, "searchBar": searchBar]
        var constraints = [NSLayoutConstraint]()
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[collectionView]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[searchBar]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        constraints.append(
            contentsOf: NSLayoutConstraint.constraints(
                withVisualFormat: "V:[searchBar]-[collectionView]|",
                options: [],
                metrics: nil,
                views: views
            )
        )
        constraints.append(
            searchBar.topAnchor.constraint(
                equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor,
                multiplier: 1.0
            )
        )
        NSLayoutConstraint.activate(constraints)

        collectionView = doctorsCollectionView
    }

    // MARK: - UICollectionViewDiffableDataSource

    func configureDataSource() {
        collectionView.register(DoctorItemCell.self, forCellWithReuseIdentifier: DoctorItemCell.reuseIdentifier)

        dataSource = UICollectionViewDiffableDataSource<Section, Doctor>(
            collectionView: collectionView
        ) { collectionView, indexPath, doctor in
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DoctorItemCell.reuseIdentifier, for: indexPath
            ) as? DoctorItemCell else {
                fatalError("Unable to dequeue cell.")
            }

            cell.label.text = doctor.fullName

            return cell
        }
    }

    // MARK: - UICollectionViewLayout

    func createLayout() -> UICollectionViewLayout {
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
            let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: layoutItem, count: 2)
            layoutGroup.interItemSpacing = .fixed(10)
            let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
            layoutSection.interGroupSpacing = 20
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

            return layoutSection
        }

        return layout
    }
}

// MARK: - UICollectionViewDelegate

extension DoctorsSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = dataSource,
              let doctor = dataSource.itemIdentifier(for: indexPath) else { return }

        presenter.didFinish(with: doctor)
    }
}

// MARK: - UISearchBarDelegate

extension DoctorsSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.performQuery(with: searchText)
    }
}

// MARK: - DoctorsSearchDisplaying

extension DoctorsSearchViewController: DoctorsSearchDisplaying {
    func doctorsSnapshot(_ doctors: [Doctor]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Doctor>()
        snapshot.appendSections([.main])
        snapshot.appendItems(doctors)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
