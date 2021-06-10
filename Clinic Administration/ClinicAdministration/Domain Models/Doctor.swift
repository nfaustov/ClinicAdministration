//
//  Doctor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.11.2020.
//

import Foundation

enum SalaryType: String, Hashable, Equatable {
    case fixedSalary = "fixed"
    case piecerateSalary = "piecerate"
}

struct Doctor: Hashable {
    var id: UUID?
    var secondName: String
    var firstName: String
    var patronymicName: String
    var phoneNumber: String
    var birthDate: Date?
    var specialization: String
    var basicService: String
    var serviceDuration: TimeInterval
    var defaultCabinet: Int?
    var info: String?
    var imageData: Data?
    var salaryType: SalaryType
    var monthlySalary: Double
    var agentSalary: Double

    var fullName: String {
        secondName + " " + firstName + " " + patronymicName
    }

    init(
        id: UUID?,
        secondName: String,
        firstName: String,
        patronymicName: String,
        phoneNumber: String,
        birthDate: Date?,
        specialization: String,
        basicService: String,
        serviceDuration: TimeInterval,
        defaultCabinet: Int?,
        info: String?,
        imageData: Data?,
        salaryType: SalaryType,
        monthlySalary: Double = 0,
        agentSalary: Double = 0
    ) {
        self.id = id
        self.secondName = secondName
        self.firstName = firstName
        self.patronymicName = patronymicName
        self.phoneNumber = phoneNumber
        self.birthDate = birthDate
        self.specialization = specialization
        self.basicService = basicService
        self.serviceDuration = serviceDuration
        self.defaultCabinet = defaultCabinet
        self.info = info
        self.imageData = imageData
        self.salaryType = salaryType
        self.monthlySalary = monthlySalary
        self.agentSalary = agentSalary
    }

    init?(entity: DoctorEntity) {
        guard let entitySecondName = entity.secondName,
              let entityFirstName = entity.firstName,
              let entityPatronymicName = entity.patronymicName,
              let entityPhoneNumber = entity.phoneNumber,
              let entitySpecialization = entity.specialization else { return nil }

        id = entity.id
        secondName = entitySecondName
        firstName = entityFirstName
        patronymicName = entityPatronymicName
        phoneNumber = entityPhoneNumber
        birthDate = entity.birthDate
        specialization = entitySpecialization
        basicService = ""
        serviceDuration = entity.serviceDuration
        defaultCabinet = Int(entity.defaultCabinet)
        info = entity.info
        imageData = entity.imageData
        salaryType = SalaryType(rawValue: entity.salaryType ?? "") ?? .fixedSalary
        monthlySalary = entity.monthlySalary
        agentSalary = entity.agentSalary
    }
}
