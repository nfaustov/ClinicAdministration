//
//  Patient.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

struct PatientAppointment: Codable, Hashable {
    var scheduledTime: Date
    var duration: TimeInterval
    var patient: Patient?

    init(scheduledTime: Date, duration: TimeInterval, patient: Patient?) {
        self.scheduledTime = scheduledTime
        self.duration = duration
        self.patient = patient
    }

    init?(entity: PatientAppointmentEntity) {
        scheduledTime = entity.sheduledTime ?? Date()
        duration = entity.duration

        if let entityPatient = entity.patient {
            patient = Patient(entity: entityPatient)
        } else {
            patient = nil
        }
    }
}

struct Patient: Codable, Hashable {
    var id: UUID?
    var secondName: String
    var firstName: String
    var patronymicName: String
    var phoneNumber: String
    let passport: PassportData?
    let placeOfResidence: PlaceOfResidence?
    let treatmentPlan: TreatmentPlan?
    let visits: [Visit]

    init(
        id: UUID? = UUID(),
        secondName: String,
        firstName: String,
        patronymicName: String,
        phoneNumber: String,
        passport: PassportData? = nil,
        placeOfResidence: PlaceOfResidence? = nil,
        treatmentPlan: TreatmentPlan? = nil,
        visits: [Visit] = []
    ) {
        self.id = id
        self.secondName = secondName
        self.firstName = firstName
        self.patronymicName = patronymicName
        self.phoneNumber = phoneNumber
        self.passport = passport
        self.placeOfResidence = placeOfResidence
        self.treatmentPlan = treatmentPlan
        self.visits = visits
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
        passport = nil
        placeOfResidence = nil
        treatmentPlan = nil
        visits = []
    }

    var fullName: String {
        secondName + " " + firstName + " " + patronymicName
    }
}

struct PassportData: Codable, Hashable {
    let secondName: String
    let name: String
    let patronymic: String
    let gender: String
    let seriesNumber: String
    let birtday: Date
    let birthPlace: String
    let issueDate: Date
    let authority: String
}

struct PlaceOfResidence: Codable, Hashable {
    let region: String
    let locality: String
    let streetAdress: String
    let house: String
    let appartment: String
}

struct TreatmentPlan: Codable, Hashable {
    enum Kind: String, Codable {
        case standard
        case pregnancy
    }

    let kind: Kind
    let startingDate: Date
    let expirationDate: Date
}

struct Visit: Codable, Hashable {
    let registrationDate: Date
    let visitDate: Date
    let doctorsConclusion: DoctorsConclusion?
    let contract: Data?
}

struct DoctorsConclusion: Codable, Hashable {
    let doctorName: String
    let service: String
    let conclusion: Data?
}
