//
//  AdminPanelInteractor.swift
//  ClinicAdministration
//
//  Created by Николай Фаустов on 14.02.2023.
//

import Foundation

final class AdminPanelInteractor {
    typealias Delegate = AdminPanelInteractorDelegate
    weak var delegate: Delegate?
}

// MARK: - AdminPanelInteraction

extension AdminPanelInteractor: AdminPanelInteraction {
}
