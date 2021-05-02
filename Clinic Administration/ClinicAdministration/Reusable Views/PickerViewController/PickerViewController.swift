//
//  PickerViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 30.04.2021.
//

import UIKit

class PickerViewController<Model: Hashable>: UIViewController,
                                   UIPickerViewDataSource,
                                   UIPickerViewDelegate,
                                   UIViewControllerTransitioningDelegate {
    private let pickerView = UIPickerView()
    private let button = UIButton()
    private let separator = UIView()

    private(set) var selectedItem0: Model?
    private(set) var selectedItem1: Model?

    var data = [Model]()
    var data1: [Model]?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Design.Color.white

        separator.backgroundColor = Design.Color.lightGray
        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self

        if pickerView.numberOfComponents == 2 {
            data1 = []
        }

        configureButton()
        setupConstraints()
    }

    func previouslyPicked(_ model: Model, model1: Model? = nil) {
        if let indexOfModel = data.firstIndex(where: { $0 == model }) {
            pickerView.selectRow(indexOfModel, inComponent: 0, animated: false)
        }

        if let indexOfModel1 = data1?.firstIndex(where: { $0 == model1 }) {
            pickerView.selectRow(indexOfModel1, inComponent: 1, animated: false)
        }
    }

    private func configureButton() {
        button.setTitle("ГОТОВО", for: .normal)
        button.setTitleColor(Design.Color.chocolate, for: .normal)
        button.titleLabel?.font = Design.Font.robotoFont(ofSize: 15, weight: .medium)
        button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        button.sizeToFit()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            separator.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            separator.widthAnchor.constraint(equalTo: view.widthAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),

            pickerView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            pickerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10),
            pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }

    @objc func confirm() {
        selectedItem0 = data[pickerView.selectedRow(inComponent: 0)]
        selectedItem1 = data1?[pickerView.selectedRow(inComponent: 1)]

        dismiss(animated: true)
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data.count
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "???"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { }

    // MARK: - UIViewControllerTransitioningDelegate

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = CustomPresentationController(
            presentedViewController: presented,
            presenting: presenting ?? source
        )

        return presentationController
    }
}
