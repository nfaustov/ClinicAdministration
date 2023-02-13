//
//  Font.swift
//  ClinicAdministration
//
//  Created by Николай Фаустов on 08.02.2023.
//

import UIKit

/// An object that generates fonts
enum Font {
    enum RobotoFontWeight: String {
        case thin = "Roboto-Thin"
        case light = "Roboto-Light"
        case regular = "Roboto-Regular"
        case medium = "Roboto-Medium"
        case bold = "Roboto-Bold"
        case black = "Roboto-Black"
    }

    /// Roboto font with font size value 11, medium weight
    static let labelSmall = robotoFont(ofSize: .labelSmall, weight: .medium)

    /// Roboto font with font size value 14, regular weight
    static let labelLarge = robotoFont(ofSize: .titleSmall, weight: .regular)

    /// Roboto font with font size value 14, medium weight
    static let titleSmall = robotoFont(ofSize: .titleSmall, weight: .medium)

    /// Roboto font with font size value 16, regular weight
    static let titleMedium = robotoFont(ofSize: .titleMedium, weight: .regular)

    /// Roboto font with font size value 18, regular weight
    static let titleLarge = robotoFont(ofSize: .titleLarge, weight: .regular)

    /// Roboto font with font size value 22, medium weight
    static let headlineSmall = robotoFont(ofSize: .headlineSmall, weight: .medium)

    /// Roboto font with font size value 24, medium weight
    static let headlineMedium = robotoFont(ofSize: .headlineMedium, weight: .medium)

    /// Creates roboto font with specified size and weight
    /// - Parameters:
    ///   - fontSize: font size
    ///   - weight: font weight
    static func robotoFont(ofSize fontSize: Standards.FontSize, weight: RobotoFontWeight) -> UIFont {
        UIFont(name: weight.rawValue, size: fontSize.rawValue) ?? UIFont()
    }
}
