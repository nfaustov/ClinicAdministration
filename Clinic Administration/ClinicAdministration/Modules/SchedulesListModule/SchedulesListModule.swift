//
//  SchedulesListModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.10.2021.
//

import Foundation

protocol SchedulesListModule: AnyObject {
    var didFinish: ((DoctorSchedule) -> Void)? { get set }
}

protocol SchedulesListDisplaying: View {
}

protocol SchedulesListPresentation: AnyObject {
    func didFinish(with schedule: DoctorSchedule)
}

protocol SchedulesListInteraction: Interactor {
}

protocol SchedulesListInteractorDelegate: AnyObject {
}
