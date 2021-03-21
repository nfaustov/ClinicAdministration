//
//  Const.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

enum Design {
    enum Color {
        static let white = #colorLiteral(red: 0.9960784314, green: 0.9960784314, blue: 0.9921568627, alpha: 1)
        static let lightGray = #colorLiteral(red: 0.8941176471, green: 0.9019607843, blue: 0.8901960784, alpha: 1)
        static let gray = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.7725490196, alpha: 1)
        static let darkGray = #colorLiteral(red: 0.6274509804, green: 0.631372549, blue: 0.5803921569, alpha: 1)
        static let brown = #colorLiteral(red: 0.4588235294, green: 0.3921568627, blue: 0.2901960784, alpha: 1)
        static let red = #colorLiteral(red: 0.3960784314, green: 0.1568627451, blue: 0.02352941176, alpha: 1)
        static let chocolate = #colorLiteral(red: 0.2352941176, green: 0.2, blue: 0.1450980392, alpha: 1)
    }

    enum CornerRadius {
        static let small: CGFloat = 5
        static let medium: CGFloat = 10
        static let large: CGFloat = 15
    }

    enum Font {
        static func robotoFont(ofSize fontSize: CGFloat, weight: RobotoFontWeight) -> UIFont {
            UIFont(name: weight.rawValue, size: fontSize) ?? UIFont()
        }
    }

    enum RobotoFontWeight: String {
        case thin = "Roboto-Thin"
        case light = "Roboto-Light"
        case regular = "Roboto-Regular"
        case medium = "Roboto-Medium"
        case bold = "Roboto-Bold"
        case black = "Roboto-Black"
    }
}
