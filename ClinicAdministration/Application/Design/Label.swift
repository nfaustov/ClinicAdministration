//
//  Label.swift
//  ClinicAdministration
//
//  Created by Николай Фаустов on 08.02.2023.
//

import UIKit

/// An object that generates labels
enum Label {
    /// Creates date label from specified date
    /// - Parameters:
    ///   - date: date
    ///   - size: text size
    ///   - textColor: text color
    /// - Returns: label with attributed text
    static func dateLabel(_ date: Date, ofSize size: Standards.FontSize, textColor: UIColor) -> UILabel {
        DateFormatter.shared.dateFormat = "LLLL d EEEE"
        let stringDate = DateFormatter.shared.string(from: date)
        let splitDate = stringDate.split(separator: " ")

        guard splitDate.count == 3 else { return UILabel() }

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

        let label = UILabel()
        label.attributedText = attributedDate

        return label
    }

    // MARK: - By font weight

    /// Creates label with thin font wheight
    /// - Parameters:
    ///   - size: font size
    ///   - color: text color
    ///   - text: text
    /// - Returns: `UILabel` with roboto font, specified size, text color and title.
    static func thin(ofSize size: Standards.FontSize, color: UIColor, withText text: String = "") -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Font.robotoFont(ofSize: size, weight: .thin)
        label.textColor = color

        return label
    }

    /// Creates label with light font wheight
    /// - Parameters:
    ///   - size: font size
    ///   - color: text color
    ///   - text: text
    /// - Returns: `UILabel` with roboto font, specified size, text color and title.
    static func light(ofSize size: Standards.FontSize, color: UIColor, withText text: String = "") -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Font.robotoFont(ofSize: size, weight: .light)
        label.textColor = color

        return label
    }

    /// Creates label with regular font wheight
    /// - Parameters:
    ///   - size: font size
    ///   - color: text color
    ///   - text: text
    /// - Returns: `UILabel` with roboto font, specified size, text color and title.
    static func regular(ofSize size: Standards.FontSize, color: UIColor, withText text: String = "") -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Font.robotoFont(ofSize: size, weight: .regular)
        label.textColor = color

        return label
    }

    /// Creates label with medium font wheight
    /// - Parameters:
    ///   - size: font size
    ///   - color: text color
    ///   - text: text
    /// - Returns: `UILabel` with roboto font, specified size, text color and title.
    static func medium(ofSize size: Standards.FontSize, color: UIColor, withText text: String = "") -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Font.robotoFont(ofSize: size, weight: .medium)
        label.textColor = color

        return label
    }

    /// Creates label with bold font wheight
    /// - Parameters:
    ///   - size: font size
    ///   - color: text color
    ///   - text: text
    /// - Returns: `UILabel` with roboto font, specified size, text color and title.
    static func bold(ofSize size: Standards.FontSize, color: UIColor, withText text: String = "") -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Font.robotoFont(ofSize: size, weight: .bold)
        label.textColor = color

        return label
    }

    /// Creates label with black font wheight
    /// - Parameters:
    ///   - size: font size
    ///   - color: text color
    ///   - text: text
    /// - Returns: `UILabel` with roboto font, specified size, text color and title.
    static func black(ofSize size: Standards.FontSize, color: UIColor, withText text: String = "") -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Font.robotoFont(ofSize: size, weight: .black)
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
