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
    var serviceDuration: TimeInterval
    var patientAppointments: [PatientAppointment]

    init(
        id: UUID? = UUID(),
        doctor: Doctor,
        startingTime: Date,
        endingTime: Date,
        cabinet: Int,
        patientAppointments: [PatientAppointment]
    ) {
        self.id = id
        self.doctor = doctor
        self.cabinet = cabinet
        self.startingTime = startingTime
        self.endingTime = endingTime
        self.serviceDuration = doctor.serviceDuration
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
        serviceDuration = doctor.serviceDuration
        patientAppointments = entityPatientAppointments.compactMap { PatientAppointment(entity: $0) }

        if self.patientAppointments.isEmpty {
            createAppointments()
        }
    }

    private mutating func createAppointments() {
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

    /// This method updates number of patient appointments when doctor schedule was changed.
    /// You can use it only if appointments not contains scheduled patients.
    mutating func updateAppointments() {
        let patients = patientAppointments.compactMap { $0.patient }
        assert(patients.isEmpty, "You can use this method only when appointments not contains scheduled patients.")

        patientAppointments.removeAll()
        createAppointments()
    }

    /// This method replace appointment with new appointment at the same scheduled time.
    /// Also it delete next  appointments if they are crossed in time interval
    /// only if they are not contains scheduled patients, in this case it send error message in completion.
    /// - Parameters:
    ///   - newAppointment: New appointment to replace
    ///   - completion: Possible error message.
    mutating func updateAppointments(with newAppointment: PatientAppointment, completion: @escaping (String?) -> Void) {
        guard let index = patientAppointments.firstIndex(where: { $0.scheduledTime == newAppointment.scheduledTime }),
              let ending = newAppointment.scheduledTime?.addingTimeInterval(newAppointment.duration) else {
                  completion("Cannot find corresponding appointment.")
            return
        }

        if newAppointment.duration == patientAppointments[index].duration {
            patientAppointments.remove(at: index)
            patientAppointments.insert(newAppointment, at: index)
        } else {
            let crossedAppointments = patientAppointments.filter { ending > $0.scheduledTime ?? Date() }

            guard crossedAppointments.compactMap({ $0.patient }).isEmpty else {
                completion(
                    "Couldn't change duration of appointment. Schedule already has patients at this time interval."
                )
                return
            }

            for appointment in crossedAppointments {
                patientAppointments.removeAll(where: { $0.scheduledTime == appointment.scheduledTime })
            }
        }
    }
}
