//
//  CreateSchedulePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation

final class CreateSchedulePresenter<V, I>: PresenterInteractor<V, I>, CreateScheduleModule
where V: CreateScheduleView, I: CreateScheduleInteraction {
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

    func pickCabinet(selected: Int?) {
        coordinator?.routeToPickCabinet(previouslyPicked: selected) { cabinet in
            guard let cabinet = cabinet else { return }

            self.view?.pickedCabinet(cabinet)
        }
    }

    func schedulePreview(_ schedule: DoctorSchedule) {
        coordinator?.routeToGraphicTimeTablePreview(schedule) { editedSchedule in
            self.didFinish?(editedSchedule)
        }
    }
}

// MARK: - CreateScheduleInteractorDelegate

extension CreateSchedulePresenter: CreateScheduleInteractorDelegate {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule], date: Date) {
        let workingHours = WorkingHours(date: date)

        var intervals = [DateInterval]()
        if schedules.isEmpty {
            view?.createdIntervals([DateInterval(start: workingHours.opening, end: workingHours.close)])
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
            start: workingHours.opening,
            end: schedules.first?.startingTime ?? Date()
        )
        let lastInterval = DateInterval(
            start: schedules.last?.endingTime ?? Date(),
            end: workingHours.close
        )
        intervals.insert(firstInterval, at: 0)
        intervals.append(lastInterval)

        view?.createdIntervals(intervals.filter { $0.duration >= 900 })
    }
}
