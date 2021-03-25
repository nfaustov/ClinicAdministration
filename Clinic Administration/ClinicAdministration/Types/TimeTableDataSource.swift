//
//  TimeTable.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.11.2020.
//

import Foundation
import Extensions

final class TimeTableDataSource {
    private var schedules: [DoctorSchedule]

    init() {
        guard let url = Bundle.main.url(forResource: "schedules", withExtension: "json") else {
            fatalError("Can't find JSON")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load JSON")
        }

        let decoder = JSONDecoder()

        DateFormatter.shared.dateFormat = "yyyy-MM-dd'T'HH:mm"
        decoder.dateDecodingStrategy = .formatted(DateFormatter.shared)

        guard let doctorSchedules = try? decoder.decode([DoctorSchedule].self, from: data) else {
            fatalError("Failed to decode JSON")
        }

        schedules = doctorSchedules
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

    func intersectedSchedules(for date: Date) -> [DoctorSchedule] {
        var intersectedSchedules = [DoctorSchedule]()
        let dateSchedules = filteredSchedules(for: date)

        for cabinet in 1...Settings.cabinets {
            let cabinetSchedules = dateSchedules.filter({ $0.cabinet == cabinet })
            if cabinetSchedules.count <= 1 { continue }
            let sortedSchedules = cabinetSchedules.sorted(by: { $0.startingTime < $1.startingTime })

            for index in 1..<sortedSchedules.count {
                let previousSchedule = sortedSchedules[index - 1]
                let currentSchedule = sortedSchedules[index]

                let compareResult = Calendar.current.compare(
                    previousSchedule.endingTime,
                    to: currentSchedule.startingTime,
                    toGranularity: .minute
                )

                if compareResult == .orderedDescending && !intersectedSchedules.contains(previousSchedule) {
                    intersectedSchedules.append(currentSchedule)
                }
            }
        }
        return intersectedSchedules
    }

    func updateSchedule(_ schedule: DoctorSchedule, updated: @escaping () -> Void) {
        for index in schedules.indices
        where schedules[index].id == schedule.id && schedules[index] != schedule {
            schedules[index] = schedule
            updated()
        }
    }
}
