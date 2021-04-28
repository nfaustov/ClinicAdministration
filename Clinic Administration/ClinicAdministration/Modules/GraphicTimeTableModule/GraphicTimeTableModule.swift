//
//  GraphicTimeTableModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import Foundation

protocol GraphicTimeTableModule: AnyObject {
    var coordinator: TimeTableCoordinator? { get set }
    var didFinish: ((_ date: Date) -> Void)? { get set }
}

protocol GraphicTimeTableDisplaying: View {
    var date: Date! { get set }

    func updateTableView(with schedules: [DoctorSchedule])

    func calendarPicked(date: Date?)
}

protocol GraphicTimeTablePresentation: AnyObject {
    func didSelected(date: Date)

    func pickDateInCalendar()

    func didFinish(with date: Date)
}

protocol GraphicTimeTableInteraction: Interactor {
    func getSchedules(for date: Date)
}

protocol GraphicTimeTableInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
}
