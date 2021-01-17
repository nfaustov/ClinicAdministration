//
//  Doctor.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 25.11.2020.
//

import Foundation

enum SalaryType: String, Codable {
    case fixedSalary = "fixed"
    case piecerateSalary = "piecerate"
}

class Doctor {
    var secondName: String
    var firstName: String
    var patronymicName: String
    var birthDate: Date
    var specialization: String // объединить в отдельный enum
    var basicService: String // специаизацию можно выбирать, базовая услуга назначается автоматически ???
    var serviceDuration: TimeInterval
    var salaryType: SalaryType
    var monthlySalary: Double
    var agentSalary: Double
    
    init(name: Person, birthDate: Date, specialization: String, basicService: String, serviceDuration: TimeInterval,
         salaryType: SalaryType, monthlySalary: Double = 0, agentSalary: Double = 0) {
        secondName = name.secondName
        firstName = name.firstName
        patronymicName = name.patronymicName
        self.birthDate = birthDate
        self.specialization = specialization
        self.basicService = basicService
        self.serviceDuration = serviceDuration
        self.salaryType = salaryType
        self.monthlySalary = monthlySalary
        self.agentSalary = agentSalary
    }
}
