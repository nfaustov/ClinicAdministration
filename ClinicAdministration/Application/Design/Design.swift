//
//  Design.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

/// An object that stores design system data
enum Design {
    /// An object that stores color data
    enum Color {
        /// A color object with hex #FEFEFD
        static let white = #colorLiteral(red: 0.9960784314, green: 0.9960784314, blue: 0.9921568627, alpha: 1)
        /// A color object with hex #E4E6E3
        static let lightGray = #colorLiteral(red: 0.8941176471, green: 0.9019607843, blue: 0.8901960784, alpha: 1)
        /// A color object with hex #D0D0C5
        static let gray = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.7725490196, alpha: 1)
        /// A color object with hex #A0A194
        static let darkGray = #colorLiteral(red: 0.6274509804, green: 0.631372549, blue: 0.5803921569, alpha: 1)
        /// A color object with hex #75644A
        static let brown = #colorLiteral(red: 0.4588235294, green: 0.3921568627, blue: 0.2901960784, alpha: 1)
        /// A color object with hex #652806
        static let red = #colorLiteral(red: 0.3960784314, green: 0.1568627451, blue: 0.02352941176, alpha: 1)
        /// A color object with hex #3C3325
        static let chocolate = #colorLiteral(red: 0.2352941176, green: 0.2, blue: 0.1450980392, alpha: 1)
    }

    /// An object that stores values for corner radius properties
    enum CornerRadius {
        /// Corner radius value 5
        static let small: CGFloat = 5
        /// Corner radius value 10
        static let medium: CGFloat = 10
        /// Corner radius value 15
        static let large: CGFloat = 15
    }
}
