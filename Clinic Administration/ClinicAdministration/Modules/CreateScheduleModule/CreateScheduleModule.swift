//
//  CreateScheduleModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation

protocol CreateScheduleModule: AnyObject {
    var coordinator: (CalendarSubscription &
                      PickTimeIntervalSubscription &
                      PickCabinetSubscription &
                      DoctorsSearchSubscription &
                      GraphicTimeTablePreviewSubscription)? { get set }
    var didFinish: ((DoctorSchedule?) -> Void)? { get set }
}

protocol CreateScheduleDisplaying: View {
    var date: Date { get set }
    var currentDoctor: Doctor? { get set }

    func pickedInterval(_ interval: (Date, Date))
    func pickedCabinet(_ cabinet: Int)
}

protocol CreateSchedulePresentation: AnyObject {
    func pickDoctor()
    func pickDateInCalendar()
    func pickTimeInterval(availableOnDate date: Date, selected: (Date, Date)?)
    func pickCabinet(selected: Int?)
    func schedulePreview(_ schedule: DoctorSchedule)
    func createSchedule(_ schedule: DoctorSchedule)
}

protocol CreateScheduleInteraction: Interactor {
    func createSchedule(_ schedule: DoctorSchedule)
}

protocol CreateScheduleInteractorDelegate: AnyObject {
    func scheduleDidCreated(_ schedule: DoctorSchedule)
}
