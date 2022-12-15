//
//  Modules.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import UIKit

protocol Modules {
    func schedule(selectedSchedule: DoctorSchedule?) -> (UIViewController, ScheduleModule)
    func graphicschedule(_ date: Date) -> (UIViewController, GraphicScheduleModule)
    func calendar() -> (UIViewController, CalendarTableModule)
    func createSchedule(for: Doctor, onDate: Date) -> (UIViewController, CreateScheduleModule)
    func doctorsSearch() -> (UIViewController, DoctorsSearchModule)
    func pickCabinet(selected: Int?) -> (UIViewController, PickCabinetModule)
    func graphicTimeTablePreview(_ schedule: DoctorSchedule) -> (UIViewController, GraphicTimeTablePreviewModule)
    func schedulesList(for doctor: Doctor) -> (UIViewController, SchedulesListModule)
    func patientAppointment(
        schedule: DoctorSchedule,
        appointment: PatientAppointment
    ) -> (UIViewController, PatientAppointmentModule)
    func patientsSearch() -> (UIViewController, PatientsSearchModule)
}
