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
    static var background: UIColor {
        Color["#E4E6E3"]
    }

    static var secondaryBackground: UIColor {
        Color["FEFEFD"]
    }

    static var tertiaryBackground: UIColor {
        Color["#A0A194"]
    }

    // MARK: - Fill colors

    static var fill: UIColor {
        Color["#652806"]
    }

    static var secondaryFill: UIColor {
        Color["#3C3325"]
    }

    // MARK: - Label colors

    static var label: UIColor {
        Color["#3C3325"]
    }

    static var lightLabel: UIColor {
        Color["FEFEFD"]
    }

    static var secondaryLabel: UIColor {
        Color["#75644A"]
    }

    static var lightSecondaryLabel: UIColor {
        Color["#E4E6E3"]
    }

    static var tertiaryLabel: UIColor {
        Color["#A0A194"]
    }

    static var quaternaryLabel: UIColor {
        Color["#D0D0C5"]
    }

    // MARK: - Text colors

    static var placeholderText: UIColor {
        Color["#A0A194"]
    }

    // MARK: - Separator colors

    static var separator: UIColor {
        Color["#D0D0C5"]
    }

    static var lightSeparator: UIColor {
        Color["#E4E6E3"]
    }

    // MARK: - Shadow colors

    static var shadow: UIColor {
        Color["#A0A194"]
    }

    static var selectedShadow: UIColor {
        Color["#75644A"]
    }

    // MARK: - Border colors

    static var border: UIColor {
        Color["#A0A194"]
    }

    static var lightBorder: UIColor {
        Color["#E4E6E3"]
    }
}

extension Color {
    static subscript(_ hex: String) -> UIColor {
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
