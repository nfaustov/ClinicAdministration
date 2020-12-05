//
//  GraphicTimeTableViewController.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

final class GraphicTimeTableViewController: UIViewController {

    private var graphicTimeTableView: GraphicTimeTableView? {
        return viewIfLoaded as? GraphicTimeTableView
    }
    
    var date = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: Date().addingTimeInterval(172800))
    
    override func loadView() {
        view = GraphicTimeTableView(date: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphicTimeTableView?.delegate = self
    }

}

extension GraphicTimeTableViewController: GraphicTimeTableViewDelegate {
    func dateChanged(_ date: DateComponents) {

    }
}
