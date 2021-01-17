//
//  TimeLineView.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 03.12.2020.
//

import UIKit

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
        let hours = tableView.close.hour! - tableView.opening.hour!
        for hour in 0...hours {
            let step: CGFloat = (hour == hours) ? 1 : 0.25
            for quarterHour in stride(from: CGFloat(0), to: CGFloat(1), by: step) {
                let minutes = Int(60 * quarterHour)
                let label = UILabel()
                label.text = (minutes == 0) ? "\(tableView.opening.hour! + hour):00" : "\(tableView.opening.hour! + hour):\(minutes)"
                label.font = Design.Font.regular(14)
                label.sizeToFit()
                label.frame.origin = CGPoint(x: 9, y: tableView.quarterHourHeight * ((CGFloat(hour) + quarterHour) * 4 + 1) - label.frame.height)
                label.textColor = Design.Color.brown
                addSubview(label)
            }
        }
    }
}
