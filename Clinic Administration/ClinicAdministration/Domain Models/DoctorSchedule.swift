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
    var startingTime: Date
    var endingTime: Date
    var patientAppointments: [PatientAppointment]

    init(
        id: UUID? = UUID(),
        doctor: Doctor,
        startingTime: Date,
        endingTime: Date,
        cabinet: Int,
        patientAppointments: [PatientAppointment] = []
    ) {
        self.id = id
        self.doctor = doctor
        self.cabinet = cabinet
        self.startingTime = startingTime
        self.endingTime = endingTime
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
        startingTime = entityStartingTime
        endingTime = entityEndingTime
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
            patientAppointments.sort { appointment0, appointment1 in
                guard let scheduledTime0 = appointment0.scheduledTime,
                      let scheduledTime1 = appointment1.scheduledTime else { return false }

                return scheduledTime0 < scheduledTime1
            }
        }
    }

    /// Replace appointments with new appointment at the same scheduled time
    /// only if they are not contains scheduled patients, otherwise it sends error message in completion.
    /// - Parameters:
    ///   - newAppointment: New appointment to insert
    ///   - completion: Possible error message.
    mutating func updateAppointments(with newAppointment: PatientAppointment, completion: @escaping (String?) -> Void) {
        guard let index = patientAppointments.firstIndex(
            where: { $0.scheduledTime == newAppointment.scheduledTime }
        ) else {
            completion("Cannot find corresponding appointment.")
            return
        }

        if newAppointment.duration == patientAppointments[index].duration {
            guard patientAppointments[index].patient == nil else {
                completion("На это время уже записан пациент: \(patientAppointments[index].patient?.fullName ?? "")")
                return
            }

            patientAppointments[index].patient = newAppointment.patient
        } else if newAppointment.duration > patientAppointments[index].duration {
            let crossedIndex = index + Int(newAppointment.duration / doctor.serviceDuration)
            let replacedPatients = patientAppointments[index...crossedIndex].compactMap { $0.patient }

            guard replacedPatients.isEmpty else {
                let fullNames = replacedPatients.map { $0.fullName }.reduce("") { $0 + ", " + $1 }
                completion("На это время уже записаны пациенты: \(fullNames)")
                return
            }

            patientAppointments.removeSubrange(index...crossedIndex)
            patientAppointments.insert(newAppointment, at: index)
        } else {
            completion(
                "Длительность приема слишком маленькая, необходимо по крайней мере \(doctor.serviceDuration / 60) мин."
            )
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
        var appointmentTime = startingTime

        repeat {
            addingAppointmentIteration(&appointmentTime)
        } while appointmentTime < endingTime
    }

    private mutating func editAppointments() {
        guard let firstPatientStarting = patientAppointments.first(where: { $0.patient != nil })?.scheduledTime,
              let lastPatient = patientAppointments.last(where: { $0.patient != nil }),
              let lastPatientEnding = lastPatient.scheduledTime?.addingTimeInterval(lastPatient.duration) else {
            return
        }

        var appointmentTime = startingTime

        while appointmentTime < firstPatientStarting {
            addingAppointmentIteration(&appointmentTime)
        }

        appointmentTime = lastPatientEnding

        while appointmentTime < endingTime {
            addingAppointmentIteration(&appointmentTime)
        }
    }
}
