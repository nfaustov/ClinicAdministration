//
//  PriceList.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.12.2022.
//

import Foundation

final class PriceList {
    let categories: [ServicesCategory]

    init(categories: [ServicesCategory]) {
        self.categories = categories
    }
}

struct ServicesCategory: Codable, Hashable {
    let tittle: String
    let subCategories: [ServicesCategory]?
    let services: [Service]?
}

struct Service: Codable, Hashable {
    let code: String
    let title: String
    let price: Double
    let costPrice: Double
}
