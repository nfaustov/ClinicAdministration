//
//  VisitsModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.12.2022.
//

import Foundation

protocol VisitsModule: AnyObject {
    var coordinator: ScheduleCoordinator? { get set }
}

protocol VisitsView: View {
}

protocol VisitsPresentation: AnyObject {
    func showVisit(_ visit: Visit)
}

protocol VisitsInteraction: Interactor {
}

protocol VisitsInteractorDelegate: AnyObject {
}
