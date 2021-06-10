//
//  GraphicTimeTablePreviewSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

protocol GraphicTimeTablePreviewSubscription: AnyObject {
    func routeToGraphicTimeTablePreview(_ schedule: DoctorSchedule, didFinish: @escaping (DoctorSchedule) -> Void)
}
