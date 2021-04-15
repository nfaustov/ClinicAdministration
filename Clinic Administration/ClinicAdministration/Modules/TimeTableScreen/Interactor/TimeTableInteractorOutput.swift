//
//  TimeTableInteractorOutput.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

protocol TimeTableInteractorOutput: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
}
