//
//  GraphicTimeTableInteractorOutput.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

protocol GraphicTimeTableInteractorOutput: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
}
