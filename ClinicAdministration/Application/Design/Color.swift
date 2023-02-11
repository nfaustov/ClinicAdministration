//
//  Color.swift
//  ClinicAdministration
//
//  Created by Николай Фаустов on 09.02.2023.
//

import UIKit

/// An object that stores color data
enum Color {
    // MARK: - Background colors
    /// The color for the main background of interface
    static var background: UIColor {
        color(withHEX: "#E4E6E3") // lightGray
    }

    static var secondaryBackground: UIColor {
        color(withHEX: "FEFEFD") // white
    }

    // MARK: - Fill colors

    static var fill: UIColor {
        color(withHEX: "#652806") // red
    }

    static var secondaryFill: UIColor {
        color(withHEX: "#3C3325") // chocolate
    }

    static var tertiaryFill: UIColor {
        Color["#A0A194"] // darkGray
    }

    // MARK: - Label colors

    static var label: UIColor {
        color(withHEX: "#3C3325") // chocolate
    }

    static var lightLabel: UIColor {
        color(withHEX: "FEFEFD") // white
    }

    static var secondaryLabel: UIColor {
        color(withHEX: "#75644A") // brown
    }

    static var lightSecondaryLabel: UIColor {
        color(withHEX: "E4E6E3") // lightGray
    }

    static var tertiaryLabel: UIColor {
        color(withHEX: "#A0A194") // darkGray
    }

    static var quaternaryLabel: UIColor {
        color(withHEX: "#D0D0C5") // gray
    }

    // MARK: - Text colors

    static var placeholderText: UIColor {
        color(withHEX: "#A0A194") // darkGray
    }

    // MARK: - Separator

    static var separator: UIColor {
        Color["#D0D0C5"] // gray
    }

    static var lightSeparator: UIColor {
        color(withHEX: "E4E6E3") // lightGray
    }

    static var darkSeparator: UIColor {
        Color["#A0A194"] // darkGray
    }

    // MARK: - Shadow

    static var selectedShadow: UIColor {
        Color["#75644A"] // brown
    }

    static var passiveShadow: UIColor {
        Color["#A0A194"] // darkGray
    }

    // MARK: - Border

    static var border: UIColor {
        Color["#A0A194"] // darkGray
    }

    static var lightBorder: UIColor {
        Color["#E4E6E3"] // lightGray
    }

    static subscript(_ hex: String) -> UIColor {
        color(withHEX: hex)
    }

    private static func color(withHEX hex: String) -> UIColor {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
            blue: CGFloat(rgbValue & 0x0000FF) / 255,
            alpha: 1
        )
    }
}
