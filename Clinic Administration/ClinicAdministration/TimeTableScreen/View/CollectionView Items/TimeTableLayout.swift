//
//  TimeTableLayout.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 01.04.2021.
//

import UIKit

class TimeTableLayout {
    let patientSectionHeaderElementKind: String
    let patientSectionFooterElementKind: String
    let patientSectionBackgroundElementKind: String

    init(
        patientSectionHeaderElementKind: String,
        patientSectionFooterElementKind: String,
        patientSectionBackgroundElementKind: String
    ) {
        self.patientSectionHeaderElementKind = patientSectionHeaderElementKind
        self.patientSectionFooterElementKind = patientSectionFooterElementKind
        self.patientSectionBackgroundElementKind = patientSectionBackgroundElementKind
    }

    func createDoctorSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 25, leading: 10, bottom: 25, trailing: 10)
        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.45),
            heightDimension: .absolute(170)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous

        return layoutSection
    }

    func createPatientSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1 / 6)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        let layoutSectionHeader = createSectionHeader()
        let layoutSectionFooter = createSectionFooter()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader, layoutSectionFooter]
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: patientSectionBackgroundElementKind
        )
        layoutSection.decorationItems = [sectionBackgroundDecoration]

        return layoutSection
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(90)
        )
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: patientSectionHeaderElementKind,
            alignment: .top
        )

        return layoutSectionHeader
    }

    private func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.85),
            heightDimension: .absolute(95)
        )
        let layoutSectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionFooterSize,
            elementKind: patientSectionFooterElementKind,
            alignment: .bottom
        )

        return layoutSectionFooter
    }
}
