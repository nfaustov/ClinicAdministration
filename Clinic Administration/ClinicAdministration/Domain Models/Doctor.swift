//
//  Doctor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.11.2020.
//

import Foundation

enum SalaryType: String, Codable {
    case fixedSalary = "fixed"
    case piecerateSalary = "piecerate"
}

class Doctor: Codable, Hashable {
    static func == (lhs: Doctor, rhs: Doctor) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var id: UUID?
    var secondName: String
    var firstName: String
    var patronymicName: String
    var phoneNumber: String
    var birthDate: Date?
    var specialization: String
    var basicService: String
    var serviceDuration: TimeInterval
    var salaryType: SalaryType
    var monthlySalary: Double
    var agentSalary: Double

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
        salaryType = SalaryType(rawValue: entity.salaryType ?? "") ?? .fixedSalary
        monthlySalary = entity.monthlySalary
        agentSalary = entity.agentSalary
    }
}
