//
//  ModulesFactory.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import UIKit

final class ModulesFactory: Modules {
    private let dependencies: DatabaseDependencies & NetworkServiceDependencies

    init(dependencies: DatabaseDependencies & NetworkServiceDependencies) {
        self.dependencies = dependencies
    }

    func adminPanel() -> (UIViewController, AdminPanelModule) {
        let view = AdminPanelViewController()
        let interactor = AdminPanelInteractor()
        let presenter = AdminPanelPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func schedule(selectedSchedule: DoctorSchedule?) -> (UIViewController, ScheduleModule) {
        let view = ScheduleViewController()
        if let selectedSchedule = selectedSchedule {
            view.selectedSchedule = selectedSchedule
            view.date = selectedSchedule.starting
        }
        let interactor = ScheduleInteractor()
        interactor.database = dependencies.doctorsDatabase
        interactor.doctorScheduleService = dependencies.doctorScheduleService
        let presenter = SchedulePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func graphicschedule(_ date: Date) -> (UIViewController, GraphicScheduleModule) {
        let view = GraphicScheduleViewController()
        view.date = date
        let interactor = GraphicScheduleInteractor()
        interactor.database = dependencies.doctorsDatabase
        interactor.doctorScheduleService = dependencies.doctorScheduleService
        let presenter = GraphicSchedulePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func calendar() -> (UIViewController, CalendarTableModule) {
        let view = CalendarTableViewController()
        let presenter = CalendarTablePresenter(view: view)

        return (view, presenter)
    }

    func createSchedule(for doctor: Doctor, onDate date: Date) -> (UIViewController, CreateScheduleModule) {
        let view = CreateScheduleViewController()
        view.currentDoctor = doctor
        view.date = date
        let interactor = CreateScheduleInteractor()
        interactor.database = dependencies.doctorsDatabase
        interactor.doctorScheduleService = dependencies.doctorScheduleService
        let presenter = CreateSchedulePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func doctorsSearch() -> (UIViewController, DoctorsSearchModule) {
        let view = DoctorsSearchViewController()
        let interactor = DoctorsSearchInteractor()
        interactor.database = dependencies.doctorsDatabase
        interactor.doctorService = dependencies.doctorService
        let presenter = DoctorsSearchPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func pickCabinet(selected cabinet: Int?) -> (UIViewController, PickCabinetModule) {
        let view = PickCabinetViewController()
        view.selectedCabinet = cabinet
        let presenter = PickCabinetPresenter(view: view)

        return (view, presenter)
    }

    func graphicTimeTablePreview(_ schedule: DoctorSchedule) -> (UIViewController, GraphicSchedulePreviewModule) {
        let view = GraphicSchedulePreviewViewController()
        view.newSchedule = schedule
        let interactor = GraphicSchedulePreviewInteractor()
        interactor.database = dependencies.doctorsDatabase
        interactor.doctorScheduleService = dependencies.doctorScheduleService
        let presenter = GraphicSchedulePreviewPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func schedulesList(for doctor: Doctor) -> (UIViewController, SchedulesListModule) {
        let view = SchedulesListViewController()
        view.doctor = doctor
        let interactor = SchedulesListInteractor()
        interactor.database = dependencies.doctorsDatabase
        interactor.doctorScheduleService = dependencies.doctorScheduleService
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
        interactor.database = dependencies.doctorsDatabase
        interactor.doctorScheduleService = dependencies.doctorScheduleService
        let presenter = PatientAppointmentPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func patientsSearch() -> (UIViewController, PatientsSearchModule) {
        let view = PatientsSearchViewController()
        let interactor = PatientsSearchInteractor()
        // interactor database
        let presenter = PatientsSearchPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func patientCard(patient: Patient) -> (UIViewController, PatientCardModule) {
        let view = PatientCardViewController()
        view.patient = patient
        let interactor = PatientCardInteractor()
        // interactor database
        let presenter = PatientCardPresenter(view: view, interactor: interactor)

        return (view, presenter)
    }
}
