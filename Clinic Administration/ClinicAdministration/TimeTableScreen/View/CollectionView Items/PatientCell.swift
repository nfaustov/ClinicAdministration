//
//  PatientCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 26.03.2021.
//

import UIKit
import Design
import Extensions

final class PatientCell: UICollectionViewCell {
    static let reuseIdentifier: String = "PatientCell"

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 24, weight: .medium)
        return label
    }()

    private var patientView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Design.Color.white
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = Design.Color.darkGray.cgColor

        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let trigonPath = UIBezierPath()
        trigonPath.move(to: CGPoint(x: frame.width - 20, y: frame.height))
        trigonPath.addLine(to: CGPoint(x: frame.width, y: frame.height))
        trigonPath.addLine(to: CGPoint(x: frame.width, y: frame.height - 20))
        trigonPath.close()
        Design.Color.gray.set()
        trigonPath.fill()
    }

    func configure(with cell: TimeTablePatientCell) {
        DateFormatter.shared.dateFormat = "H:mm"

        timeLabel.text = DateFormatter.shared.string(from: cell.scheduledTime)

        patientView?.removeFromSuperview()

        if let patient = cell.patient {
            timeLabel.textColor = Design.Color.darkGray

            patientView = TimeTablePatientView(
                secondName: patient.secondName,
                firstName: patient.firstName,
                patronymicName: patient.patronymicName,
                phoneNumber: patient.phoneNumber
            )

            guard let patientView = patientView else { return }

            addSubview(patientView)

            patientView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                patientView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                patientView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
                patientView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.82),
                patientView.heightAnchor.constraint(equalToConstant: 70)
            ])
        } else {
            timeLabel.textColor = Design.Color.chocolate
        }
    }
}
