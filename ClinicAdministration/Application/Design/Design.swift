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

    /// An object that generates fonts
    enum Font {
        /// Creates roboto font with specified size and weight
        /// - Parameters:
        ///   - fontSize: font size
        ///   - weight: font weight
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

    /// An object that generates labels
    enum Label {
        /// An object that stores values for font size properties
        enum Size: CGFloat {
            /// Font size value 11
            case labelSmall = 11
            /// Font size value 14
            case titleSmall = 14
            /// Font size value 16
            case titleMedium = 16
            /// Font size value 18
            case titleLarge = 18
            /// Font size value 22
            case headlineSmall = 22
            /// Font size value 24
            case headlineMedium = 24
        }
        /// Creates date label from specified date
        /// - Parameters:
        ///   - date: date
        ///   - size: text size
        ///   - textColor: text color
        /// - Returns: label with attributed text
        static func dateLabel(_ date: Date, ofSize size: CGFloat, textColor: UIColor) -> UILabel {
            let label = UILabel()

            DateFormatter.shared.dateFormat = "LLLL d EEEE"
            let stringDate = DateFormatter.shared.string(from: date)
            let splitDate = stringDate.split(separator: " ")
            let month = "\(splitDate[0].capitalized.replacingOccurrences(of: ".", with: ""))"
            let day = "\(splitDate[1])"
            let weekday = "\(splitDate[2])"

            let attributedDate = NSMutableAttributedString(
                string: "\(month) \(day) \(weekday)",
                attributes: [.foregroundColor: textColor]
            )
            attributedDate.addAttributes(
                    [.font: Font.robotoFont(ofSize: size, weight: .medium)],
                    range: NSRange(location: 0, length: month.count)
                )
            attributedDate.addAttributes(
                [.font: Font.robotoFont(ofSize: size, weight: .regular)],
                range: NSRange(location: month.count + 1, length: day.count)
            )
            attributedDate.addAttributes(
                [.font: Font.robotoFont(ofSize: size, weight: .light)],
                range: NSRange(location: month.count + day.count + 2, length: weekday.count)
            )

            label.attributedText = attributedDate

            return label
        }

        /// Creates title label
        /// - Parameter title: label title
        /// - Returns: label with specified title, roboto font of size 13, regular weight, dark gray text color
        static func titleLabel(_ title: String) -> UILabel {
            let label = UILabel()
            label.text = title
            label.font = Design.Font.robotoFont(ofSize: 13, weight: .regular)
            label.textColor = Color.darkGray

            return label
        }

        /// Creates value label
        /// - Returns: label with roboto font of size 18, regular weight, light gray text color
        static func valueLabel() -> UILabel {
            let label = UILabel()
            label.font = Design.Font.robotoFont(ofSize: 18, weight: .regular)
            label.textColor = Design.Color.lightGray

            return label
        }
        
        // MARK: - By font weight

        /// Creates label with thin font wheight
        /// - Parameters:
        ///   - size: font size
        ///   - color: text color
        ///   - text: text
        /// - Returns: `UILabel` with roboto font, specified size, text color and title.
        static func thin(ofSize size: Label.Size, color: UIColor, withText text: String = "") -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = Design.Font.robotoFont(ofSize: size.rawValue, weight: .thin)
            label.textColor = color

            return label
        }

        /// Creates label with light font wheight
        /// - Parameters:
        ///   - size: font size
        ///   - color: text color
        ///   - text: text
        /// - Returns: `UILabel` with roboto font, specified size, text color and title.
        static func light(ofSize size: Label.Size, color: UIColor, withText text: String = "") -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = Design.Font.robotoFont(ofSize: size.rawValue, weight: .light)
            label.textColor = color

            return label
        }

        /// Creates label with regular font wheight
        /// - Parameters:
        ///   - size: font size
        ///   - color: text color
        ///   - text: text
        /// - Returns: `UILabel` with roboto font, specified size, text color and title.
        static func regular(ofSize size: Label.Size, color: UIColor, withText text: String = "") -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = Design.Font.robotoFont(ofSize: size.rawValue, weight: .regular)
            label.textColor = color

            return label
        }

        /// Creates label with medium font wheight
        /// - Parameters:
        ///   - size: font size
        ///   - color: text color
        ///   - text: text
        /// - Returns: `UILabel` with roboto font, specified size, text color and title.
        static func medium(ofSize size: Label.Size, color: UIColor, withText text: String = "") -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = Design.Font.robotoFont(ofSize: size.rawValue, weight: .medium)
            label.textColor = color

            return label
        }

        /// Creates label with bold font wheight
        /// - Parameters:
        ///   - size: font size
        ///   - color: text color
        ///   - text: text
        /// - Returns: `UILabel` with roboto font, specified size, text color and title.
        static func bold(ofSize size: Label.Size, color: UIColor, withText text: String = "") -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = Design.Font.robotoFont(ofSize: size.rawValue, weight: .bold)
            label.textColor = color

            return label
        }

        /// Creates label with black font wheight
        /// - Parameters:
        ///   - size: font size
        ///   - color: text color
        ///   - text: text
        /// - Returns: `UILabel` with roboto font, specified size, text color and title.
        static func black(ofSize size: Label.Size, color: UIColor, withText text: String = "") -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = Design.Font.robotoFont(ofSize: size.rawValue, weight: .black)
            label.textColor = color

            return label
        }

        // MARK: - By style
        
        /// Creates label with medium font weight of size 11
        /// - Parameters:
        ///   - color: text color
        ///   - text: text
        /// - Returns: `UILabel` with roboto font, specified text color and title.
        static func labelSmall(color: UIColor, withText text: String = "") -> UILabel {
            medium(ofSize: .labelSmall, color: color, withText: text)
        }

        /// Creates label with regular font weight of size 14
        /// - Parameters:
        ///   - color: text color
        ///   - text: text
        /// - Returns: `UILabel` with roboto font, specified text color and title.
        static func labelLarge(color: UIColor, withText text: String = "") -> UILabel {
            regular(ofSize: .titleSmall, color: color, withText: text)
        }

        /// Creates label with medium font weight of size 14
        /// - Parameters:
        ///   - color: text color
        ///   - text: text
        /// - Returns: `UILabel` with roboto font, specified text color and title.
        static func titleSmall(color: UIColor, withText text: String = "") -> UILabel {
            medium(ofSize: .titleSmall, color: color, withText: text)
        }

        /// Creates label with regular font weight of size 16
        /// - Parameters:
        ///   - color: text color
        ///   - text: text
        /// - Returns: `UILabel` with roboto font, specified text color and title.
        static func titleMedium(color: UIColor, withText text: String = "") -> UILabel {
            regular(ofSize: .titleMedium, color: color, withText: text)
        }

        /// Creates label with regular font weight of size 18
        /// - Parameters:
        ///   - color: text color
        ///   - text: text
        /// - Returns: `UILabel` with roboto font, specified text color and title.
        static func titleLarge(color: UIColor, withText text: String = "") -> UILabel {
            regular(ofSize: .titleLarge, color: color, withText: text)
        }

        /// Creates label with medium font weight of size 22
        /// - Parameters:
        ///   - color: text color
        ///   - text: text
        /// - Returns: `UILabel` with roboto font, specified text color and title.
        static func headlineSmall(color: UIColor, withText text: String = "") -> UILabel {
            medium(ofSize: .headlineSmall, color: color, withText: text)
        }

        /// Creates label with medium font weight of size 24
        /// - Parameters:
        ///   - color: text color
        ///   - text: text
        /// - Returns: `UILabel` with roboto font, specified text color and title.
        static func headlineMedium(color: UIColor, withText text: String = "") -> UILabel {
            medium(ofSize: .headlineMedium, color: color, withText: text)
        }
    }
}
