//
//  VisitsInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.12.2022.
//

import Foundation

final class VisitsInteractor {
    typealias Delegate = VisitsInteractorDelegate
    weak var delegate: Delegate?
}

// MARK: - VisitsInteractiron

extension VisitsInteractor: VisitsInteraction {
}
