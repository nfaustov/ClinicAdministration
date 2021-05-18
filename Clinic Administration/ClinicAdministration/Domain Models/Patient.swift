//
//  Patient.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

struct PatientAppointment: Codable, Hashable {
    var scheduledTime: Date?
    var duration: TimeInterval
    var patient: Patient?

    init(scheduledTime: Date?, duration: TimeInterval, patient: Patient?) {
        self.scheduledTime = scheduledTime
        self.duration = duration
        self.patient = patient
    }

    init?(entity: PatientAppointmentEntity) {
        guard let entityPatient = entity.patient else { return nil }

        scheduledTime = entity.sheduledTime
        duration = entity.duration
        patient = Patient(entity: entityPatient)
    }
}

struct Patient: Codable, Hashable {
    var id: UUID?
    var secondName: String
    var firstName: String
    var patronymicName: String
    var phoneNumber: String

    init(id: UUID?, secondName: String, firstName: String, patronymicName: String, phoneNumber: String) {
        self.id = id
        self.secondName = secondName
        self.firstName = firstName
        self.patronymicName = patronymicName
        self.phoneNumber = phoneNumber
    }

    init?(entity: PatientEntity) {
        guard let entitySecondName = entity.secondName,
              let entityFirstName = entity.firstName,
              let entityPatronymicName = entity.patronymicName,
              let entityPhoneNumber = entity.phoneNumber else { return nil }

        id = entity.id
        secondName = entitySecondName
        firstName = entityFirstName
        patronymicName = entityPatronymicName
        phoneNumber = entityPhoneNumber
    }
}
