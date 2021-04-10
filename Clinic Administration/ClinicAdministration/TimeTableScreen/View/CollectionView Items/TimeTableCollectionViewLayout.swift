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
    let doctorSectionHeaderElementKind: String
    let actionListBackgroundElementKind: String

    init(
        patientSectionHeaderElementKind: String,
        actionListFooterElementKind: String,
        patientSectionBackgroundElementKind: String,
        doctorSectionHeaderElementKind: String,
        actionListBackgroundElementKind: String
    ) {
        self.patientSectionHeaderElementKind = patientSectionHeaderElementKind
        self.actionListFooterElementKind = actionListFooterElementKind
        self.patientSectionBackgroundElementKind = patientSectionBackgroundElementKind
        self.doctorSectionHeaderElementKind = doctorSectionHeaderElementKind
        self.actionListBackgroundElementKind = actionListBackgroundElementKind
    }

    // MARK: - Doctor section & supplementary items

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
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 72, bottom: 0, trailing: 0)
        let layoutSectionHeader = createDoctorSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        layoutSection.supplementariesFollowContentInsets = false
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.visibleItemsInvalidationHandler = { visibleItems, contentOffset, _ in
            guard let leadingHeader = visibleItems
                    .first(where: { $0.representedElementKind == self.doctorSectionHeaderElementKind }) else { return }

            leadingHeader.transform = CGAffineTransform(translationX: -contentOffset.x, y: 0)
        }

        return layoutSection
    }

    private func createDoctorSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .absolute(72),
            heightDimension: .absolute(170)
        )
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: doctorSectionHeaderElementKind,
            alignment: .leading
        )

        return layoutSectionHeader
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
