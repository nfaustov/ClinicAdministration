//
//  Doctor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.11.2020.
//

import Foundation

enum SalaryType: String, Hashable, Equatable, Codable {
    case fixedSalary = "fixed"
    case piecerateSalary = "piecerate"
}

struct Doctor: Codable, Hashable {
    var id: UUID?
    var secondName: String
    var firstName: String
    var patronymicName: String
    var phoneNumber: String
    var birthDate: Date?
    var specialization: String
    var basicService: String?
    var serviceDuration: TimeInterval
    var defaultCabinet: Int?
    var info: String?
    var imageData: Data?

    var fullName: String {
        secondName + " " + firstName + " " + patronymicName
    }

    var initials: String {
        guard let firstNameLetter = firstName.first,
              let patronymicNameLetter = patronymicName.first else { return secondName }

        return "\(secondName) \(firstNameLetter).\(patronymicNameLetter)"
    }

    init(
        id: UUID? = UUID(),
        secondName: String,
        firstName: String,
        patronymicName: String,
        phoneNumber: String,
        birthDate: Date?,
        specialization: String,
        basicService: String?,
        serviceDuration: TimeInterval,
        defaultCabinet: Int? = nil,
        info: String? = nil,
        imageData: Data? = nil
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
    }
}
