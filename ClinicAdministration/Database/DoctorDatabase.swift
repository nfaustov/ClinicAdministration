//
//  DoctorDatabase.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.05.2021.
//

import Foundation
import CoreData

final class DoctorDatabase: Database {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DoctorModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Mock data

//    let doctors = [
//        Doctor(
//            id: UUID(uuidString: "9bc68b57-bdac-4452-b80a-8dc116311486"),
//            secondName: "Рошаль",
//            firstName: "Леонид",
//            patronymicName: "Михайлович",
//            phoneNumber: "8-999-999-9999",
//            birthDate: Date(),
//            specialization: "Травматолог",
//            basicService: "",
//            serviceDuration: 1500,
//            salaryType: .fixedSalary
//        ),
//        Doctor(
//            id: UUID(uuidString: "7e5ad74f-0427-449c-9b77-74ce5266b825"),
//            secondName: "Перельман",
//            firstName: "Михаил",
//            patronymicName: "Израйлевич",
//            phoneNumber: "8-000-000-0000",
//            birthDate: Date(),
//            specialization: "Физиопульмонолог",
//            basicService: "",
//            serviceDuration: 1800,
//            salaryType: .piecerateSalary
//        ),
//        Doctor(
//            id: UUID(uuidString: "5f88e55f-608e-4ba6-b1a9-977014323814"),
//            secondName: "Бокерия",
//            firstName: "Лео",
//            patronymicName: "Антонович",
//            phoneNumber: "8-999-222-3344",
//            birthDate: Date(),
//            specialization: "Сосудистый хирург",
//            basicService: "",
//            serviceDuration: 1800,
//            salaryType: .fixedSalary
//        ),
//        Doctor(
//            id: UUID(uuidString: "9f07c865-af8e-4155-9977-e268a6ea1010"),
//            secondName: "Аншина",
//            firstName: "Маргарита",
//            patronymicName: "Бениаминовна",
//            phoneNumber: "8-999-999-0000",
//            birthDate: Date(),
//            specialization: "Гинеколог-эндокринолог",
//            basicService: "",
//            serviceDuration: 1800,
//            salaryType: .fixedSalary
//        ),
//        Doctor(
//            id: UUID(uuidString: "04a934b9-6168-4ae7-94cb-a8a6a84abbf8"),
//            secondName: "Разумовский",
//            firstName: "Александр",
//            patronymicName: "Юрьевич",
//            phoneNumber: "8-888-999-2222",
//            birthDate: Date(),
//            specialization: "Детский хирург",
//            basicService: "",
//            serviceDuration: 1800,
//            salaryType: .piecerateSalary
//        ),
//        Doctor(
//            id: UUID(uuidString: "620a4fe9-9828-487c-925c-3c5d422dfbde"),
//            secondName: "Дземешкевич",
//            firstName: "Сергей",
//            patronymicName: "Леонидович",
//            phoneNumber: "8-000-999-0000",
//            birthDate: Date(),
//            specialization: "Кардиохирург",
//            basicService: "",
//            serviceDuration: 1800,
//            salaryType: .fixedSalary
//        )
//    ]
//
//    init() {
//        doctors.forEach { create(objectWithModel: $0) }
//    }

    // MARK: - Create

    func create(objectWithModel model: Doctor) {
        let doctor = DoctorEntity(context: context)
        doctor.id = model.id
        doctor.secondName = model.secondName
        doctor.firstName = model.firstName
        doctor.patronymicName = model.patronymicName
        doctor.phoneNumber = model.phoneNumber
        doctor.birthDate = model.birthDate
        doctor.specialization = model.specialization
        if let cabinet = model.defaultCabinet { doctor.defaultCabinet = Int16(cabinet) }
        doctor.serviceDuration = model.serviceDuration

        update()
    }

    func createDoctorSchedule(_ schedule: DoctorSchedule) {
        let doctor = readDoctor(for: schedule)

        if let scheduleEntity = NSEntityDescription.insertNewObject(
            forEntityName: "DoctorSchedule",
            into: context
        ) as? DoctorScheduleEntity {
            scheduleEntity.id = schedule.id
            scheduleEntity.cabinet = Int16(schedule.cabinet)
            scheduleEntity.startingTime = schedule.starting
            scheduleEntity.endingTime = schedule.ending
            scheduleEntity.doctor = doctor

            schedule.patientAppointments.forEach { appointment in
                if let patientAppointmentEntity = NSEntityDescription.insertNewObject(
                    forEntityName: "PatientAppointment",
                    into: context
                ) as? PatientAppointmentEntity {
                    patientAppointmentEntity.scheduledTime = appointment.scheduledTime
                    patientAppointmentEntity.duration = appointment.duration
                    patientAppointmentEntity.schedule = scheduleEntity
                }
            }
        }

        update()
    }

    // MARK: - Read

    func read() -> [DoctorEntity] {
        let request: NSFetchRequest = DoctorEntity.fetchRequest()

        guard let doctors = try? context.fetch(request) else {
            return []
        }

        return doctors
    }

    func readDoctor(for schedule: DoctorSchedule) -> DoctorEntity {
        let request: NSFetchRequest = DoctorEntity.fetchRequest()
        request.predicate = NSPredicate(format: "phoneNumber = %@", schedule.doctor.phoneNumber)

        guard let doctor = try? context.fetch(request).first else {
            fatalError("There is no doctor for this schedule.")
        }

        return doctor
    }

    func readSchedules(for date: Date) -> [DoctorScheduleEntity] {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let dayAfterDateComponents = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: date.addingTimeInterval(86_400)
        )

        guard let comparedDate = Calendar.current.date(from: dateComponents) as NSDate?,
              let comparedDayAfterDate = Calendar.current.date(from: dayAfterDateComponents) as NSDate? else {
            return []
        }

        let request: NSFetchRequest = DoctorScheduleEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "startingTime > %@ AND startingTime < %@",
            argumentArray: [comparedDate, comparedDayAfterDate]
        )

        guard let schedules = try? context.fetch(request) else {
            return []
        }

        return schedules
    }

    func readSchedules(for doctor: Doctor) -> [DoctorScheduleEntity] {
        guard let id = doctor.id else { return [] }

        let request: NSFetchRequest = DoctorScheduleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "doctor.id == %@", id as CVarArg)

        guard let schedules = try? context.fetch(request) else {
            return []
        }

        return schedules
    }

    // MARK: - Update

    func update(changes: (() -> Void)? = nil) {
        changes?()

        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }

    func updateSchedule(_ schedule: DoctorSchedule) {
        guard let idString = schedule.id?.uuidString else { return }

        let request: NSFetchRequest = DoctorScheduleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", idString)

        guard let scheduleEntity = try? context.fetch(request).first else { return }

        update {
            scheduleEntity.startingTime = schedule.starting
            scheduleEntity.endingTime = schedule.ending
            scheduleEntity.patientAppointments = []
            schedule.patientAppointments.forEach { appointment in
                if let patientAppointmentEntity = NSEntityDescription.insertNewObject(
                    forEntityName: "PatientAppointment",
                    into: self.context
                ) as? PatientAppointmentEntity {
                    patientAppointmentEntity.scheduledTime = appointment.scheduledTime
                    patientAppointmentEntity.duration = appointment.duration
                    patientAppointmentEntity.schedule = scheduleEntity
                    if let patientEntity = NSEntityDescription.insertNewObject(
                        forEntityName: "Patient",
                        into: self.context
                    ) as? PatientEntity {
                        guard let patient = appointment.patient else { return }

                        patientEntity.id = patient.id
                        patientEntity.secondName = patient.secondName
                        patientEntity.firstName = patient.firstName
                        patientEntity.patronymicName = patient.patronymicName
                        patientEntity.phoneNumber = patient.phoneNumber

                        patientAppointmentEntity.patient = patientEntity
                    }
                }
            }
        }
    }

    // MARK: - Delete

    func delete(object: DoctorEntity) {
        context.delete(object)
        update()
    }

    func deleteSchedule(_ schedule: DoctorSchedule) {
        guard let idString = schedule.id?.uuidString else { return }

        let request: NSFetchRequest = DoctorScheduleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", idString)

        guard let scheduleEntity = try? context.fetch(request).first else { return }

        context.delete(scheduleEntity)
        update()
    }
}
