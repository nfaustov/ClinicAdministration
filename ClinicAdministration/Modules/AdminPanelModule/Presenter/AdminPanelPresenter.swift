//
//  AdminPanelPresenter.swift
//  ClinicAdministration
//
//  Created by Николай Фаустов on 14.02.2023.
//

import Foundation

final class AdminPanelPresenter<V, I>: PresenterInteractor<V, I>,
                                       AdminPanelModule where V: AdminPanelView, I: AdminPanelInteraction {
    weak var coordinator: AdminPanelCoordinator?
}

// MARK: - AdminPanelPresentation

extension AdminPanelPresenter: AdminPanelPresentation {
}

// MARK: - AdminPanelInteractorDelegate

extension AdminPanelPresenter: AdminPanelInteractorDelegate {
}
