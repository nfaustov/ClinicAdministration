//
//  CreateSchedulePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation

final class CreateSchedulePresenter<V, I>: PresenterInteractor<V, I>, CreateScheduleModule
where V: CreateScheduleDisplaying, I: CreateScheduleInteraction {
    weak var coordinator: (CalendarSubscription &
                           PickCabinetSubscription &
                           DoctorsSearchSubscription &
                           GraphicTimeTablePreviewSubscription)?

    var didFinish: ((DoctorSchedule?) -> Void)?
}

// MARK: - CreateSchedulePresentation

extension CreateSchedulePresenter: CreateSchedulePresentation {
    func makeIntervals(onDate date: Date, forCabinet cabinet: Int) {
        interactor.getSchedules(onDate: date, forCabinet: cabinet)
    }

    func pickDoctor() {
        coordinator?.routeToDoctorsSearch { doctor in
            guard let doctor = doctor else { return }

            self.view?.currentDoctor = doctor
        }
    }

    func pickDateInCalendar() {
        coordinator?.routeToCalendar { date in
            guard let date = date else { return }

            self.view?.pickedDate(date)
        }
    }

    func pickTimeInterval(availableOnDate date: Date, selected: (Date, Date)?) {
//        coordinator?.routeToPickTimeInterval(date: date, previouslyPicked: selected) { starting, ending in
//            guard let starting = starting,
//                  let ending = ending else { return }
//
//            self.view?.pickedInterval((starting, ending))
//        }
    }

    func pickCabinet(selected: Int?) {
        coordinator?.routeToPickCabinet(previouslyPicked: selected) { cabinet in
            guard let cabinet = cabinet else { return }

            self.view?.pickedCabinet(cabinet)
        }
    }

    func schedulePreview(_ schedule: DoctorSchedule) {
        coordinator?.routeToGraphicTimeTablePreview(schedule) { editedSchedule in
            self.view?.pickedInterval((editedSchedule.startingTime, editedSchedule.endingTime))
        }
    }

    func createSchedule(_ schedule: DoctorSchedule) {
        interactor.createSchedule(schedule)
    }
}

// MARK: - CreateScheduleInteractorDelegate

extension CreateSchedulePresenter: CreateScheduleInteractorDelegate {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule], date: Date) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        var opening = dateComponents
        var close = dateComponents

        switch dateComponents.weekday {
        case 1:
            opening.hour = 9
            close.hour = 15
        case 7:
            opening.hour = 9
            close.hour = 18
        default:
            opening.hour = 8
            close.hour = 19
        }

        guard let openingDate = calendar.date(from: opening),
              let closeDate = calendar.date(from: close) else { return }

        var intervals = [DateInterval]()
        if schedules.isEmpty {
            view?.createdIntervals([DateInterval(start: openingDate, end: closeDate)])
            return
        } else if schedules.count > 1 {
            for index in 1..<schedules.count {
                let previousSchedule = schedules[index - 1]
                let currentSchedule = schedules[index]
                let freeInterval = DateInterval(
                    start: previousSchedule.endingTime,
                    end: currentSchedule.startingTime
                )
                intervals.append(freeInterval)
            }
        }
        let firstInterval = DateInterval(
            start: openingDate,
            end: schedules.first?.startingTime ?? Date()
        )
        let lastInterval = DateInterval(
            start: schedules.last?.endingTime ?? Date(),
            end: closeDate
        )
        intervals.insert(firstInterval, at: 0)
        intervals.append(lastInterval)

        view?.createdIntervals(intervals.filter { $0.duration >= 900 })
    }

    func scheduleDidCreated(_ schedule: DoctorSchedule) {
        didFinish?(schedule)
    }
}
