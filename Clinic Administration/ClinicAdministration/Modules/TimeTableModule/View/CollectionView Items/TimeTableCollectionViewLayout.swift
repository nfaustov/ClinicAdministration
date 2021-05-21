//
//  TimeTableCollectionViewLayout.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 01.04.2021.
//

import UIKit

final class TimeTableCollectionViewLayout {
    let patientSectionHeaderElementKind: String
    let actionListFooterElementKind: String
    let patientSectionBackgroundElementKind: String
    let actionListBackgroundElementKind: String

    init(
        patientSectionHeaderElementKind: String,
        actionListFooterElementKind: String,
        patientSectionBackgroundElementKind: String,
        actionListBackgroundElementKind: String
    ) {
        self.patientSectionHeaderElementKind = patientSectionHeaderElementKind
        self.actionListFooterElementKind = actionListFooterElementKind
        self.patientSectionBackgroundElementKind = patientSectionBackgroundElementKind
        self.actionListBackgroundElementKind = actionListBackgroundElementKind
    }

    // MARK: - Doctor section

    func createDoctorSection(count: Int = 0) -> NSCollectionLayoutSection {
        let doctorItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let doctorLayoutItem = NSCollectionLayoutItem(layoutSize: doctorItemSize)
        doctorLayoutItem.contentInsets = NSDirectionalEdgeInsets(top: 25, leading: 10, bottom: 25, trailing: 10)
        let doctorLayoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(CGFloat(count) * 170),
            heightDimension: .fractionalHeight(1)
        )
        let doctorLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: doctorLayoutGroupSize,
            subitem: doctorLayoutItem,
            count: count
        )

        let controlItemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(72),
            heightDimension: .fractionalHeight(1)
        )
        let controlLayoutItem = NSCollectionLayoutItem(layoutSize: controlItemSize)

        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(72 + CGFloat(count) * 170),
            heightDimension: .absolute(170)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutGroupSize,
            subitems: [controlLayoutItem, doctorLayoutGroup]
        )
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous

        return layoutSection
    }

    func createDoctorPlaceholder() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(170)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: 1)
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)

        return layoutSection
    }

    // MARK: - Patient section & supplementary items

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
        let layoutSectionHeader = createPatientSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: patientSectionBackgroundElementKind
        )
        layoutSection.decorationItems = [sectionBackgroundDecoration]

        return layoutSection
    }

    private func createPatientSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(90)
        )
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: patientSectionHeaderElementKind,
            alignment: .top
        )
        layoutSectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)

        return layoutSectionHeader
    }

    // MARK: - Action list section & supplementary items

    func createActionListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(45)
        )
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0)
        let layoutSectionFooter = createActionListFooter()
        layoutSection.boundarySupplementaryItems = [layoutSectionFooter]
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: actionListBackgroundElementKind
        )
        sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 12,
            bottom: 0,
            trailing: 12
        )
        layoutSection.decorationItems = [sectionBackgroundDecoration]

        return layoutSection
    }

    private func createActionListFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.85),
            heightDimension: .absolute(75)
        )
        let layoutSectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionFooterSize,
            elementKind: actionListFooterElementKind,
            alignment: .bottom
        )

        return layoutSectionFooter
    }
}
