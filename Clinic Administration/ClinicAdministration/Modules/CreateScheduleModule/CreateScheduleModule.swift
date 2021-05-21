//
//  CreateScheduleModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation

protocol CreateScheduleModule: AnyObject {
    var coordinator: (CalendarSubscription &
                      PickDoctorSubscription &
                      PickTimeIntervalSubscription &
                      PickCabinetSubscription &
                      AddScheduleSubscription)? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol CreateScheduleDisplaying: View {
    var date: Date { get set }
    var doctorsList: [Doctor] { get set }

    func pickedDoctor(_ doctor: Doctor)
    func pickedInterval(_ interval: (Date, Date))
    func pickedCabinet(_ cabinet: Int)
}

protocol CreateSchedulePresentation: AnyObject {
    func pickDateInCalendar()
    func pickDoctor(from: [Doctor], selected: Doctor?)
    func pickTimeInterval(availableOnDate date: Date, selected: (Date, Date)?)
    func pickCabinet(selected: Int?)
    func addSchedule(_ schedule: DoctorSchedule)
    func getDoctors()
}

protocol CreateScheduleInteraction: Interactor {
    func getDoctors()
}

protocol CreateScheduleInteractorDelegate: AnyObject {
    func doctorsDidRecieved(_ doctors: [Doctor])
}
