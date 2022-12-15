//
//  SearchViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 07.12.2022.
//

import UIKit

class SearchViewController<Model: Hashable>: UIViewController {
    enum Section: Int {
        case filter
        case result
    }

    var searchBar = UISearchBar()

    var searchCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!

    var resultList = [Model]()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
    }

    private func configureHierarchy() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        searchBar.placeholder = "Поиск"
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        let views = ["collectionView": collectionView, "searchBar": searchBar]
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

        searchCollectionView = collectionView
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self,
                  let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section type.")
            }

            guard let filterSectionLayout = self.createFilterSectionLayout() else {
                return self.createResultSectionLayout()
            }

            switch section {
            case .filter: return filterSectionLayout
            case .result: return self.createResultSectionLayout()
            }
        }

        return layout
    }

    func createResultSectionLayout() -> NSCollectionLayoutSection {
        fatalError("This method must be overriden")
    }

    func createFilterSectionLayout() -> NSCollectionLayoutSection? {
        nil
    }
}
