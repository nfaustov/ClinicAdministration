//
//  Array-DoctorSchedule.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 31.12.2020.
//

import Foundation

extension Array where Element == DoctorSchedule {
    
    /// Метод для сортировки расписаний врачей по времени начала приема.
    /// - Parameter result: Необходимый параметр сортировки.
    func sortedByStartingTime(_ result: ComparisonResult) -> Self {
        return self.sorted { (schedule1, schedule2) -> Bool in
            let firstStartingTime = Calendar.current.date(from: schedule1.startingTime)
            let secondStartingTime = Calendar.current.date(from: schedule2.startingTime)
            let compareResult = Calendar.current.compare(firstStartingTime!, to: secondStartingTime!, toGranularity: .minute)
            return compareResult == result
        }
    }
}
