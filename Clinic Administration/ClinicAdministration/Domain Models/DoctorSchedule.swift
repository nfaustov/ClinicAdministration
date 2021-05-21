//
//  DoctorSchedule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import Foundation

struct DoctorSchedule: Codable, Equatable, Hashable {
    let id: UUID?
    let secondName: String
    let firstName: String
    let patronymicName: String
    let phoneNumber: String
    let specialization: String
    var cabinet: Int
    var startingTime: Date
    var endingTime: Date
    var serviceDuration: TimeInterval
    var patientAppointments: [PatientAppointment]

    init(
        id: UUID?,
        secondName: String,
        firstName: String,
        patronymicName: String,
        phoneNumber: String,
        specialization: String,
        cabinet: Int,
        startingTime: Date,
        endingTime: Date,
        serviceDuration: TimeInterval,
        patientAppointments: [PatientAppointment] = []
    ) {
        self.id = id
        self.secondName = secondName
        self.firstName = firstName
        self.patronymicName = patronymicName
        self.phoneNumber = phoneNumber
        self.specialization = specialization
        self.cabinet = cabinet
        self.startingTime = startingTime
        self.endingTime = endingTime
        self.serviceDuration = serviceDuration
        self.patientAppointments = patientAppointments

        if self.patientAppointments.isEmpty {
            createAppointments()
        }
    }

    init?(entity: DoctorScheduleEntity) {
        guard let entityDoctor = entity.doctor,
              let doctor = Doctor(entity: entityDoctor),
              let entityStartingTime = entity.startingTime,
              let entityEndingTime = entity.endingTime,
              let entityPatientAppointments = entity.patientAppointments?.array
                as? [PatientAppointmentEntity] else { return nil }

        id = entity.id
        secondName = doctor.secondName
        firstName = doctor.firstName
        patronymicName = doctor.patronymicName
        phoneNumber = doctor.phoneNumber
        specialization = doctor.specialization
        cabinet = Int(entity.cabinet)
        startingTime = entityStartingTime
        endingTime = entityEndingTime
        serviceDuration = doctor.serviceDuration
        patientAppointments = entityPatientAppointments.compactMap { PatientAppointment(entity: $0) }

        if self.patientAppointments.isEmpty {
            createAppointments()
        }
    }

    mutating func createAppointments() {
        var appointmentTime = startingTime

        repeat {
            let appointment = PatientAppointment(
                scheduledTime: appointmentTime,
                duration: serviceDuration,
                patient: nil
            )
            patientAppointments.append(appointment)
            appointmentTime.addTimeInterval(serviceDuration)
        } while appointmentTime < endingTime
    }
}