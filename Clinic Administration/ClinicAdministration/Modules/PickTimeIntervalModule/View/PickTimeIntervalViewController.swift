//
//  PickTimeIntervalViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import UIKit

class PickTimeIntervalViewController: PickerViewController<Date> {
    typealias PresenterType = PickTimeIntervalPresentation
    var presenter: PresenterType!

    private let calendar = Calendar.current

    var date: Date!

    override func viewDidLoad() {
        super.viewDidLoad()

        makeIntervals()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presenter.didFinish(with: (selectedItem0, selectedItem1))
    }

    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }

    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let formatter = DateFormatter.shared
        formatter.dateFormat = "H:mm"

        guard let data1 = data1 else { return nil }

        return component == 0 ? formatter.string(from: data[row]) : formatter.string(from: data1[row])
    }

    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedRow0 = pickerView.selectedRow(inComponent: 0)

        if pickerView.selectedRow(inComponent: 1) < selectedRow0 {
            pickerView.selectRow(selectedRow0, inComponent: 1, animated: true)
        }
    }

    private func makeIntervals() {
        var openingDateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        var closeDateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: date)

        switch openingDateComponents.weekday {
        case 1:
            openingDateComponents.hour = 9
            closeDateComponents.hour = 15
        case 7:
            openingDateComponents.hour = 9
            closeDateComponents.hour = 18
        default:
            openingDateComponents.hour = 8
            closeDateComponents.hour = 19
        }

        guard let openingHour = openingDateComponents.hour,
              let closeHour = closeDateComponents.hour,
              let openingDate = calendar.date(from: openingDateComponents) else { return }

        let intervalsCount = (closeHour - openingHour) * 12 - 2
        let fiveMinutesInterval = 300

        for intervalNumber in 0...intervalsCount {
            let intervalPoint = openingDate.addingTimeInterval(TimeInterval(intervalNumber * fiveMinutesInterval))
            data.append(intervalPoint)
            data1?.append(intervalPoint.addingTimeInterval(600))
        }
    }
}

// MARK: - PickTimeIntervalDisplaying

extension PickTimeIntervalViewController: PickTimeIntervalDisplaying { }
