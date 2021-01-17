//
//  TimeTable.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 21.11.2020.
//

import Foundation

/// Класс для хранения и управления базой данных с расписаниями докторов.
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let doctorSchedules = try? decoder.decode([DoctorSchedule].self, from: data) else {
            fatalError("Failed to decode JSON")
        }
        
        schedules = doctorSchedules
    }
    
    init(schedules: [DoctorSchedule]) {
        self.schedules = schedules
    }
    
    /// Данный метод возвращает все расписания на определенную дату.
    /// - Parameter date: Необхоимая дата.
    func filteredSchedules(for date: Date) -> [DoctorSchedule] {
        var filteredSchedules = [DoctorSchedule]()
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        for schedule in schedules {
            let scheduleStartingComponents = Calendar.current.dateComponents([.year, .month, .day], from: schedule.startingTime)
            if dateComponents == scheduleStartingComponents {
                filteredSchedules.append(schedule)
            }
        }
        
        return filteredSchedules
    }
    
    /// Данный метод возвращает список всех пересекающихся расписаний на определенную дату.
    ///
    /// Не все пересекающиеся расписания попадают в этот массив, а каждое второе.
    /// - Parameter date: Необходимая дата.
    
    // Он нужен здесь в dataSource, потому что будет и другой экран с расписаниями врачей (не графический),
    // которому будет нужна эта информация, чтобы уведомлять пользователя, даже когда `GraphicTimeTableScreen` еще не загружен
    func intersectedSchedules(for date: Date) -> [DoctorSchedule] {
        var intersectedSchedules = [DoctorSchedule]()
        let dateSchedules = filteredSchedules(for: date)
        
        for cabinet in 1...Settings.cabinets {
            // Сортируем расписания в кабинете по времени начала приема (по возрастанию).
            let cabinetSchedules = dateSchedules.filter({ $0.cabinet == cabinet })
            if cabinetSchedules.count <= 1 { continue }
            let sortedSchedules = cabinetSchedules.sorted(by: { $0.startingTime < $1.startingTime })
            
            for index in 1..<sortedSchedules.count {
                let previousSchedule = sortedSchedules[index - 1]
                let currentSchedule = sortedSchedules[index]
                
                // Сравниваем два соседних расписания.
                let compareResult = Calendar.current.compare(
                    previousSchedule.endingTime,
                    to: currentSchedule.startingTime,
                    toGranularity: .minute)
                
                // Чисто визуально выглядит грязно, если все покрасить в красный,
                // однако, если подумать, то и логика в этом есть: мы как бы говорим пользователю с чего начать или
                // какое расписание переместить, чтобы убрать пересечение.
                if compareResult == .orderedDescending && !intersectedSchedules.contains(previousSchedule) {
                    intersectedSchedules.append(currentSchedule)
                }
            }
        }
        return intersectedSchedules
    }
    
    /// Данный метод используется для обновления расписания доктора, если он был изменен.
    ///
    /// Мы можм использовать его, чтобы проверить было ли изменено расписание доктора
    /// и затем произвести необходимые действия, если были изменения.
    ///
    /// - Parameters:
    ///   - schedule: Расписание, которое нужно обновить.
    ///   - updated: Блок, который вызывается, если расписание было обновлено.
    func updateSchedule(_ schedule: DoctorSchedule, updated: @escaping () -> Void) {
        for index in schedules.indices {
            if schedules[index].id == schedule.id {
                if schedules[index] != schedule {
                    schedules[index] = schedule
                    // у модели расписания появилось поле id, так как расписание могло быть изменено, и иначе найти его не получится.
                    // Можно было бы по имени искать, однако нельзя отрицать кейсы,
                    // когда один врач может иметь два расписания на один день.
                    updated()
                }
            }
        }
    }
}
