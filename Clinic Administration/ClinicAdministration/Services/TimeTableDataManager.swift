//
//  TimeTabledataManager.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.11.2020.
//

import Foundation

final class TimeTableDataManager {
    private var schedules: [DoctorSchedule]

    init() {
        schedules = Bundle.main.decode([DoctorSchedule].self, from: "schedules", dateFormat: .standard)
    }

    init(schedules: [DoctorSchedule]) {
        self.schedules = schedules
    }

    func filteredSchedules(for date: Date) -> [DoctorSchedule] {
        var filteredSchedules = [DoctorSchedule]()
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)

        for schedule in schedules {
            let scheduleStartingComponents = Calendar.current.dateComponents(
                [.year, .month, .day],
                from: schedule.startingTime
            )

            if dateComponents == scheduleStartingComponents {
                filteredSchedules.append(schedule)
            }
        }

        return filteredSchedules
    }

//    func intersectedSchedules(for date: Date) -> [DoctorSchedule] {
//        var intersectedSchedules = [DoctorSchedule]()
//        let dateSchedules = filteredSchedules(for: date)
//
//        for cabinet in 1...Settings.cabinets {
//            let cabinetSchedules = dateSchedules.filter({ $0.cabinet == cabinet })
//            if cabinetSchedules.count <= 1 { continue }
//            let sortedSchedules = cabinetSchedules.sorted(by: { $0.startingTime < $1.startingTime })
//
//            for index in 1..<sortedSchedules.count {
//                let previousSchedule = sortedSchedules[index - 1]
//                let currentSchedule = sortedSchedules[index]
//
//                let compareResult = Calendar.current.compare(
//                    previousSchedule.endingTime,
//                    to: currentSchedule.startingTime,
//                    toGranularity: .minute
//                )
//
//                if compareResult == .orderedDescending && !intersectedSchedules.contains(previousSchedule) {
//                    intersectedSchedules.append(currentSchedule)
//                }
//            }
//        }
//        return intersectedSchedules
//    }

    func updateSchedule(_ schedule: DoctorSchedule, updated: @escaping () -> Void) {
        for index in schedules.indices
        where schedules[index].id == schedule.id && schedules[index] != schedule {
            schedules[index] = schedule
            updated()
        }
    }
}
