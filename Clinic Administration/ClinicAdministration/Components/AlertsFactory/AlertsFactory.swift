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
        let doctorNameString =
            schedule.secondName + " "
            + schedule.firstName + " "
            + schedule.patronymicName
        let alertViewController = UIAlertController(
            title: "Удаление расписания",
            message: "Вы уверены, что хотите удалить расписание врача: \(doctorNameString)?",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "ДА", style: .destructive) { _ in
            alertViewController.dismiss(animated: true) {
                confirmAction(schedule)
            }
        }
        let cancelAction = UIAlertAction(title: "ОТМЕНА", style: .cancel) { _ in
            alertViewController.dismiss(animated: true)
        }
        alertViewController.addAction(confirmAction)
        alertViewController.addAction(cancelAction)

        return alertViewController
    }
}
