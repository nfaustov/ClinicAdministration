//
//  CreateScheduleModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation

protocol CreateScheduleModule: AnyObject {
    var coordinator: (CalendarSubscription &
                      PickCabinetSubscription &
                      DoctorsSearchSubscription &
                      GraphicTimeTablePreviewSubscription)? { get set }
    var didFinish: ((DoctorSchedule?) -> Void)? { get set }
}

protocol CreateScheduleDisplaying: View {
    var currentDoctor: Doctor? { get set }

    func createdIntervals(_ intervals: [DateInterval])
    func pickedCabinet(_ cabinet: Int)
    func pickedDate(_ date: Date)
}

protocol CreateSchedulePresentation: AnyObject {
    func makeIntervals(onDate: Date, forCabinet: Int)
    func pickDoctor()
    func pickDateInCalendar()
    func pickCabinet(selected: Int?)
    func schedulePreview(_ schedule: DoctorSchedule)
}

protocol CreateScheduleInteraction: Interactor {
    func getSchedules(onDate: Date, forCabinet: Int)
}

protocol CreateScheduleInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule], date: Date)
}
