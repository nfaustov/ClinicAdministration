//
//  TimeTable.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 21.11.2020.
//

import Foundation

class TimeTableDataSource {
    
    private(set) var schedules = [DoctorSchedule]()
    
    init() {
        guard let url = Bundle.main.url(forResource: "schedules", withExtension: "json") else {
            fatalError("Can't find JSON")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load JSON")
        }
        
        let decoder = JSONDecoder()
        
        guard let doctorSchedules = try? decoder.decode([DoctorSchedule].self, from: data) else {
            fatalError("Failed to decode JSON")
        }
        
        schedules = doctorSchedules
    }
    
    func filterSchedules(for date: DateComponents) -> [DoctorSchedule] {
        return schedules.filter { $0.startingTime.year == date.year && $0.startingTime.month == date.month && $0.startingTime.day == date.day }
    }
}
