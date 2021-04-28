//
//  CreateScheduleModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation

protocol CreateScheduleModule: AnyObject {
    var coordinator: (CalendarSubscription & PickDoctorSubscription)? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol CreateScheduleDisplaying: View {
    var date: Date { get set }
}

protocol CreateSchedulePresentation: AnyObject {
    func pickDateInCalendar()

    func pickDoctor()
}

protocol CreateScheduleInteraction: Interactor {
}

protocol CreateScheduleInteractorDelegate: AnyObject {
}
