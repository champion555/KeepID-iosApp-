//
//  DatePickerPopViewController.swift
//  VeriFace
//
//  Created by Admin on 9/18/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class DatePickerPopViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnSave: UIButton!
    var selectedDate: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        selectedDate = formatter.string(from: self.datePicker.date)
    }
    func configureView(){
        btnSave.layer.cornerRadius = 10
    }
    @IBAction func onSave(_ sender: Any) {
        dismiss(animated: true)
        Constants.datePickerDate = selectedDate
    }
    
}
