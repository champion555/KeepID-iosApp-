//
//  KYCSettingBirthViewController.swift
//  VeriFace
//
//  Created by Admin on 9/4/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
class KYCSettingBirthViewController: UIViewController {
    @IBOutlet weak var txtBirth: UITextField!
    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var modelbackView: UIView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    var date: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        markView.birthDropShadow()
        configureView()
        modelbackView.isHidden = true
        datePickerView.isHidden = true
        let birth = AppUtils.getValueFromUserDefaults(key: "birthday")
        if birth != nil{
            txtBirth.text = birth
        }
    }
    func configureView(){
        contentView.cornerRadius = 10
        markView.cornerRadius = 50
        btnSave.layer.cornerRadius = 10
        datePickerView.layer.cornerRadius = 20
        btnDone.layer.cornerRadius = 10
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onSelected(_ sender: Any) {
        modelbackView.isHidden = false
        datePickerView.isHidden = false
    }
    @IBAction func onDone(_ sender: Any) {
        modelbackView.isHidden = true
        datePickerView.isHidden = true
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtBirth.text = formatter.string(from: self.datePicker.date)
    }
    @IBAction func onSave(_ sender: Any) {
        let birthday = txtBirth.text!
        if birthday.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Please select birthday")
            return
        }
        AppUtils.savetoUserDefaults(value: birthday, key: "birthday")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCProfileSettingViewController") as! KYCProfileSettingViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
extension UIView {
    func birthDropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
