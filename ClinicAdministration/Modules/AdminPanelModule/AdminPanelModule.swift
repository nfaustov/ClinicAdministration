//
//  AdminPanelModule.swift
//  ClinicAdministration
//
//  Created by Николай Фаустов on 14.02.2023.
//

import Foundation

protocol AdminPanelModule: AnyObject {
    var coordinator: AdminPanelCoordinator? { get set }
}

protocol AdminPanelView: BaseView {
}

protocol AdminPanelPresentation: AnyObject {
}

protocol AdminPanelInteraction: BaseInteractor {
}

protocol AdminPanelInteractorDelegate: AnyObject {
}
