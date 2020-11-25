//
//  Const.swift
//  Clinic Administration
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
    
    enum Shape {
        static let smallCornerRadius: CGFloat = 5
        static let mediumCornerRadius: CGFloat = 10
        static let largeCornerRadius: CGFloat = 15
    }
    
    enum Font {
        static func black(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-Black", size: size)!
        }
        static func bold(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-Bold", size: size)!
        }
        static func medium(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-Medium", size: size)!
        }
        static func regular(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-Regular", size: size)!
        }
        static func light(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-Light", size: size)!
        }
        static func thin(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-Thin", size: size)!
        }
    }
}

