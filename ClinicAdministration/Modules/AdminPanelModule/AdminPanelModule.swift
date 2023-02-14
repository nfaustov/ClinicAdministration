//
//  AdminPanelModule.swift
//  ClinicAdministration
//
//  Created by Николай Фаустов on 14.02.2023.
//

import Foundation

protocol AdminPanelModule: AnyObject {
    var coordinator: MainCoordinator? { get set }
}

protocol AdminPanelView: View {
}

protocol AdminPanelPresentation: AnyObject {
}

protocol AdminPanelInteraction: Interactor {
}

protocol AdminPanelInteractorDelegate: AnyObject {
}
