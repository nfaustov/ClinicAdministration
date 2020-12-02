//
//  GraphicTimeTableViewController.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

class GraphicTimeTableViewController: UIViewController {
    
    private let vScrollView = UIScrollView()
    private let hScrollView = UIScrollView()
    
    private var datePicker: DatePicker!
    private var timeTableView: GraphicTimeTableView!
    
    var date = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: Date(timeInterval: 86400, since: Date()))  // можно отобразить этот вью контроллер с определенной начальной датой, в планах также добавить и пикеру возможность открываться не на сегодняшней дате изначально
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Design.Color.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        datePicker = DatePicker(selectedDate: date)
        timeTableView = GraphicTimeTableView(date: date)
        
        view.addSubview(vScrollView)
        vScrollView.showsVerticalScrollIndicator = false
        vScrollView.addSubview(datePicker)

        hScrollView.showsHorizontalScrollIndicator = false
        hScrollView.isPagingEnabled = true
        hScrollView.addSubview(timeTableView)
        vScrollView.addSubview(hScrollView)
        
        datePicker.delegate = self
//        timeTableView.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let timeLineHeight = CGFloat(timeTableView.close.hour! - timeTableView.opening.hour!) * timeTableView.hourHeight // высота временной шкалы
        let tableViewHeight = timeLineHeight + timeTableView.quarterHourHeight + 2 * GraphicTimeTableView.Size.headerHeight + 1
        let tableViewWidth = GraphicTimeTableView.Size.timelineWidth + (view.bounds.width - GraphicTimeTableView.Size.timelineWidth) / 3 * CGFloat(timeTableView.cabinets)
        // на экране всегда 3 кабинета
        
        vScrollView.frame = view.bounds
        datePicker.frame = CGRect(x: 12, y: 16, width: view.bounds.width - 24, height: 90)
        hScrollView.frame = CGRect(x: 0, y: datePicker.frame.maxY + 25, width: view.bounds.width, height: tableViewHeight)
        vScrollView.contentSize = CGSize(width: view.bounds.width, height: tableViewHeight + datePicker.frame.height + 25 + 25 + 16)
        hScrollView.contentSize = CGSize(width: tableViewWidth, height: tableViewHeight)
        timeTableView.frame = CGRect(x: 0, y: 0, width: tableViewWidth, height: tableViewHeight)
    }
}

extension GraphicTimeTableViewController: DatePickerDelegate {
    func selectedDate(_ date: DateComponents) {
        timeTableView.date = date
        timeTableView.reloadData()
    }
}

//extension GraphicTimeTableViewController: TimeTableViewDelegate {
//    func scheduleDidTransform(by y: CGFloat) {
//        let rect = CGRect(x: 0, y: y, width: view.bounds.width, height: 200)
//        vScrollView.scrollRectToVisible(rect, animated: true)
//    }
//}
