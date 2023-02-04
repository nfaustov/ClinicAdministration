//
//  PatientAppointment.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.12.2022.
//

import Foundation

struct PatientAppointment: Codable, Hashable {
    let id: UUID?
    var scheduledTime: Date
    var duration: TimeInterval
    var patient: Patient?

    init(id: UUID? = UUID(), scheduledTime: Date, duration: TimeInterval, patient: Patient?) {
        self.id = id
        self.scheduledTime = scheduledTime
        self.duration = duration
        self.patient = patient
    }

    init?(entity: PatientAppointmentEntity) {
        self.id = UUID()
        scheduledTime = entity.scheduledTime ?? Date()
        duration = entity.duration

        if let entityPatient = entity.patient {
            patient = Patient(entity: entityPatient)
        } else {
            patient = nil
        }
    }
}
