//
//  TimeLineView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 03.12.2020.
//

import UIKit
import Design

final class TimelineView: UIView {
    var tableView: GraphicTableView {
        didSet {
            for subview in subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }

    init(respectiveTo tableView: GraphicTableView) {
        self.tableView = tableView
        super.init(frame: .zero)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        guard let closeHour = tableView.close.hour,
              let openingHour = tableView.opening.hour else { return }
        
        let hours = closeHour - openingHour
        
        for hour in 0...hours {
            let step: CGFloat = (hour == hours) ? 1 : 0.25
            
            for quarterHour in stride(from: CGFloat(0), to: CGFloat(1), by: step) {
                let minutes = Int(60 * quarterHour)
                let label = UILabel()
                label.text = (minutes == 0) ?
                    "\(openingHour + hour):00" :
                    "\(openingHour + hour):\(minutes)"
                label.font = Design.Font.robotoFont(ofSize: 14, weight: .regular)
                label.sizeToFit()
                label.frame.origin = CGPoint(
                    x: 9,
                    y: tableView.quarterHourHeight * ((CGFloat(hour) + quarterHour) * 4 + 1) - label.frame.height
                )
                label.textColor = Design.Color.brown
                addSubview(label)
            }
        }
    }
}
