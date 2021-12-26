//
//  AlertsFactory.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.05.2021.
//

import UIKit

final class AlertsFactory {
    static func makeRemoveSchedule(
        _ schedule: DoctorSchedule,
        confirmAction: @escaping (DoctorSchedule) -> Void
    ) -> UIAlertController {
        let alertController = UIAlertController(
            title: "Удаление расписания",
            message: "Вы уверены, что хотите удалить расписание врача: \(schedule.doctor.fullName)?",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "ДА", style: .destructive) { _ in
            alertController.dismiss(animated: true) {
                confirmAction(schedule)
            }
        }
        let cancelAction = UIAlertAction(title: "ОТМЕНА", style: .cancel) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        return alertController
    }

    static func makeNoNextSchedule(
        for doctor: Doctor,
        createAction: @escaping (Doctor, Date) -> Void
    ) -> UIAlertController {
        let alertController = UIAlertController(
            title: "Нет будущих расписаний",
            message: "Создать новое расписание врача: \(doctor.fullName)?",
            preferredStyle: .alert
        )
        let createAction = UIAlertAction(title: "ДА", style: .default) { _ in
            alertController.dismiss(animated: true) {
                createAction(doctor, Date())
            }
        }
        let cancelAction = UIAlertAction(title: "НЕТ", style: .cancel) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)

        return alertController
    }

    static func makeDefault(message: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Понятно", style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(confirmAction)

        return alertController
    }
}
