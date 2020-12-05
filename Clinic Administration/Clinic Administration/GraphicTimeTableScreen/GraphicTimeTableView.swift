//
//  GraphicTimeTableView.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 05.12.2020.
//

import UIKit

protocol GraphicTimeTableViewDelegate: AnyObject {
    func dateChanged(_ date: DateComponents)
}

final class GraphicTimeTableView: UIView {

    private let vScrollView = UIScrollView()
    private let hScrollView = UIScrollView()
    
    private var timelineHeight: CGFloat {
        CGFloat(tableView.close.hour! - tableView.opening.hour!) * tableView.hourHeight + tableView.quarterHourHeight
    }
    private var tableViewHeight: CGFloat {
        timelineHeight + 2 * GraphicTableView.Size.headerHeight
    }
    
    private var hScrollViewHeightConstraint = NSLayoutConstraint()
    private var timeTableViewHeightConstraint = NSLayoutConstraint()
    private var timelineHeightConstraint = NSLayoutConstraint()
    
    weak var delegate: GraphicTimeTableViewDelegate?
    
    private var tableView: GraphicTableView!
    private var timelineView: TimelineView!
    
    var date: DateComponents
    
    init(date: DateComponents) {
        self.date = date
        super.init(frame: .zero)
        
        backgroundColor = Design.Color.lightGray
        
        let datePicker = DatePicker(selectedDate: date, dateAction: changeDate(to:))
        tableView = GraphicTableView(date: date)
        timelineView = TimelineView(respectiveTo: tableView)

        addSubview(vScrollView)
        vScrollView.showsVerticalScrollIndicator = false
        vScrollView.addSubview(datePicker)
        
        hScrollView.showsHorizontalScrollIndicator = false
        hScrollView.isPagingEnabled = true
        hScrollView.bounces = false
        hScrollView.addSubview(tableView)
        vScrollView.addSubview(hScrollView)
        vScrollView.addSubview(timelineView)
        
        for view in [datePicker, tableView, timelineView, hScrollView, vScrollView] {
            view?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let tableViewWidth = GraphicTableView.Size.timelineWidth + (screenWidth - GraphicTableView.Size.timelineWidth) / 3 * CGFloat(tableView.cabinets)
        
        hScrollViewHeightConstraint = hScrollView.frameLayoutGuide.heightAnchor.constraint(equalToConstant: tableViewHeight)
        timeTableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableViewHeight)
        timelineHeightConstraint = timelineView.heightAnchor.constraint(equalToConstant: timelineHeight)

        NSLayoutConstraint.activate([
            vScrollView.topAnchor.constraint(equalTo: topAnchor),
            vScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            vScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            vScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            datePicker.topAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.topAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.leadingAnchor, constant: 12),
            datePicker.trailingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.trailingAnchor, constant: -12),
            datePicker.heightAnchor.constraint(equalToConstant: 90),
            
            hScrollView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 25),
            hScrollView.leadingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.leadingAnchor),
            hScrollView.trailingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.trailingAnchor),
            hScrollView.bottomAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.bottomAnchor, constant: -25),
            hScrollView.widthAnchor.constraint(equalTo: vScrollView.frameLayoutGuide.widthAnchor),
            hScrollViewHeightConstraint,
            
            tableView.topAnchor.constraint(equalTo: hScrollView.contentLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: hScrollView.contentLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: hScrollView.contentLayoutGuide.trailingAnchor),
            tableView.widthAnchor.constraint(equalToConstant: tableViewWidth),
            timeTableViewHeightConstraint,
            
            timelineView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: GraphicTableView.Size.headerHeight),
            timelineView.leadingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.leadingAnchor),
            timelineHeightConstraint,
            timelineView.widthAnchor.constraint(equalToConstant: GraphicTableView.Size.timelineWidth)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changeDate(to newDate: DateComponents) {
        tableView.date = newDate
        timelineView.timeTableView = tableView
        hScrollViewHeightConstraint.constant = tableViewHeight
        timeTableViewHeightConstraint.constant = tableViewHeight
        timelineHeightConstraint.constant = timelineHeight
        delegate?.dateChanged(newDate)
    }
}
