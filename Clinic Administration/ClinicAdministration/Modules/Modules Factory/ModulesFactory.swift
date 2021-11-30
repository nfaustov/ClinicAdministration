//
//  ModulesFactory.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import UIKit

final class ModulesFactory: Modules {
    private let dependencies: DatabaseDependencies & HttpServiceDependencies

    init(dependencies: DatabaseDependencies & HttpServiceDependencies) {
        self.dependencies = dependencies
    }

    func timeTable(selectedSchedule: DoctorSchedule?) -> (UIViewController, TimeTableModule) {
        let view = TimeTableViewController()
        if let selectedSchedule = selectedSchedule {
            view.newSchedule = selectedSchedule
            view.date = selectedSchedule.startingTime
        }
        let interactor = TimeTableInteractor()
        interactor.database = dependencies.doctorsDatabase
        let presenter = TimeTablePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func graphicTimeTable(_ date: Date) -> (UIViewController, GraphicTimeTableModule) {
        let view = GraphicTimeTableViewController()
        view.date = date
        let interactor = GraphicTimeTableInteractor()
        interactor.database = dependencies.doctorsDatabase
        let presenter = GraphicTimeTablePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func calendar() -> (UIViewController, CalendarModule) {
        let view = CalendarViewController()
        let presenter = CalendarPresenter(view: view)

        return (view, presenter)
    }

    func createSchedule(for doctor: Doctor, onDate date: Date) -> (UIViewController, CreateScheduleModule) {
        let view = CreateScheduleViewController()
        view.currentDoctor = doctor
        view.date = date
        let interactor = CreateScheduleInteractor()
        interactor.database = dependencies.doctorsDatabase
        let presenter = CreateSchedulePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func doctorsSearch() -> (UIViewController, DoctorsSearchModule) {
        let view = DoctorsSearchViewController()
        let interactor = DoctorsSearchInteractor()
        interactor.database = dependencies.doctorsDatabase
        let presenter = DoctorsSearchPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func pickCabinet(selected cabinet: Int?) -> (UIViewController, PickCabinetModule) {
        let view = PickCabinetViewController()
        view.selectedCabinet = cabinet
        let presenter = PickCabinetPresenter(view: view)

        return (view, presenter)
    }

    func graphicTimeTablePreview(_ schedule: DoctorSchedule) -> (UIViewController, GraphicTimeTablePreviewModule) {
        let view = GraphicTimeTablePreviewViewController()
        view.newSchedule = schedule
        let interactor = GraphicTimeTablePreviewInteractor()
        interactor.database = dependencies.doctorsDatabase
        let presenter = GraphicTimeTablePreviewPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func schedulesList(for doctor: Doctor) -> (UIViewController, SchedulesListModule) {
        let view = SchedulesListViewController()
        view.doctor = doctor
        let interactor = SchedulesListInteractor()
        interactor.database = dependencies.doctorsDatabase
        let presenter = SchedulesListPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func patientAppointment(
        schedule: DoctorSchedule,
        appointment: PatientAppointment
    ) -> (UIViewController, PatientAppointmentModule) {
        let view = PatientAppointmentViewController()
        view.schedule = schedule
        view.appointment = appointment
        let interactor = PatientAppointmentInteractor()
        let presenter = PatientAppointmentPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }
}
