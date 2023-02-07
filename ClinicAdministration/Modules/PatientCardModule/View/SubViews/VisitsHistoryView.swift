//
//  VisitsHistoryView.swift
//  ClinicAdministration
//
//  Created by Николай Фаустов on 07.02.2023.
//

import UIKit

final class VisitsHistoryView: UIView {
    enum Filter: String {
        case thisYear = "В этом году"
        case allTime = "За всё время"
    }

    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Визиты"
        label.textColor = Design.Color.white
        label.font = Design.Font.robotoFont(ofSize: 24, weight: .bold)
        return label
    }()

    private var filter: Filter = .thisYear
    private var visits: [Visit]

    init(visits: [Visit]) {
        self.visits = visits
        super.init(frame: .zero)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        layer.backgroundColor = Design.Color.chocolate.cgColor
        layer.cornerRadius = Design.CornerRadius.large
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let visitsView = VisitsView(visits: visits)

        for view in [titleLabel, visitsView] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            visitsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            visitsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            visitsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            visitsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
