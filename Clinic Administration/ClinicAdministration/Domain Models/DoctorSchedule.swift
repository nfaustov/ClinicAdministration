//
//  DoctorSchedule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import Foundation

struct DoctorSchedule: Codable, Equatable, Hashable {
    let id: UUID?
    let doctor: Doctor
    var cabinet: Int
    var starting: Date
    var ending: Date
    var patientAppointments: [PatientAppointment]

    init(
        id: UUID? = UUID(),
        doctor: Doctor,
        starting: Date,
        ending: Date,
        cabinet: Int,
        patientAppointments: [PatientAppointment] = []
    ) {
        self.id = id
        self.doctor = doctor
        self.cabinet = cabinet
        self.starting = starting
        self.ending = ending
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
        self.doctor = doctor
        cabinet = Int(entity.cabinet)
        starting = entityStartingTime
        ending = entityEndingTime
        patientAppointments = entityPatientAppointments.compactMap { PatientAppointment(entity: $0) }

        if self.patientAppointments.isEmpty {
            createAppointments()
        }
    }

    /// Updates number of patient appointments, excluding impact on already scheduled patients.
    mutating func updateAppointments() {
        if patientAppointments.compactMap({ $0.patient }).isEmpty {
            patientAppointments.removeAll()
            createAppointments()
        } else {
            patientAppointments.removeAll(where: { $0.patient == nil })
            editAppointments()
            patientAppointments.sort { $0.scheduledTime < $1.scheduledTime }
        }
    }

    /// Replace appointments with new appointment at the same scheduled time.
    /// - Parameters:
    ///   - newAppointment: New appointment to update
    mutating func updateAppointments(with newAppointment: PatientAppointment) {
        guard let index = patientAppointments.firstIndex(
            where: { $0.scheduledTime == newAppointment.scheduledTime }
        ) else {
            preconditionFailure("Cannot find corresponding appointment.")
        }

        if newAppointment.duration == patientAppointments[index].duration {
            patientAppointments[index].patient = newAppointment.patient
        } else if newAppointment.duration > patientAppointments[index].duration {
            let crossedIndex = index + Int(newAppointment.duration / doctor.serviceDuration)
            precondition(
                crossedIndex <= patientAppointments.count,
                "Длительность приема выходит за рамки длительности расписания."
            )

            let replacedPatients = patientAppointments[index..<crossedIndex].compactMap { $0.patient }
            precondition(replacedPatients.isEmpty, "На данном интервале уже есть записанный пациент")

            patientAppointments.removeSubrange(index..<crossedIndex)
            patientAppointments.insert(newAppointment, at: index)
        } else {
            preconditionFailure(
                "Длительность приема слишком маленькая, необходимо по крайней мере \(doctor.serviceDuration / 60) мин."
            )
        }
    }

    mutating func maxServiceDuration(for appointment: PatientAppointment) -> TimeInterval {
        if let nextReservedAppointment = patientAppointments
            .filter({ $0.scheduledTime > appointment.scheduledTime })
            .first(where: { $0.patient != nil }) {
            return nextReservedAppointment.scheduledTime.timeIntervalSince(appointment.scheduledTime)
        } else {
            return ending.timeIntervalSince(appointment.scheduledTime)
        }
    }
}

// MARK: - Private methods

extension DoctorSchedule {
    private mutating func addingAppointmentIteration(_ appointmentTime: inout Date) {
        let appointment = PatientAppointment(
            scheduledTime: appointmentTime,
            duration: doctor.serviceDuration,
            patient: nil
        )
        patientAppointments.append(appointment)
        appointmentTime.addTimeInterval(doctor.serviceDuration)
    }

    private mutating func createAppointments() {
        var appointmentTime = starting

        repeat {
            addingAppointmentIteration(&appointmentTime)
        } while appointmentTime < ending
    }

    private mutating func editAppointments() {
        guard let firstPatientStarting = patientAppointments.first(where: { $0.patient != nil })?.scheduledTime,
              let lastPatient = patientAppointments.last(where: { $0.patient != nil }) else {
            return
        }

        var appointmentTime = starting

        while appointmentTime < firstPatientStarting {
            addingAppointmentIteration(&appointmentTime)
        }

        appointmentTime = lastPatient.scheduledTime.addingTimeInterval(lastPatient.duration)

        while appointmentTime < ending {
            addingAppointmentIteration(&appointmentTime)
        }
    }
}
