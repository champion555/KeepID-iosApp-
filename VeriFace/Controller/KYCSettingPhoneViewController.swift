//
//  KYCSettingPhoneViewController.swift
//  VeriFace
//
//  Created by Admin on 9/4/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import NKVPhonePicker
class KYCSettingPhoneViewController: UIViewController {

    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var txtPhone: NKVPhonePickerTextField!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        markView.phoneDropShadow()
        configureView()
        txtPhone.phonePickerDelegate = self

    }
    func configureView(){
        contentView.cornerRadius = 10
        markView.cornerRadius = 50
        btnSave.layer.cornerRadius = 10
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onSave(_ sender: Any) {
        let phoneNum = txtPhone.text!
        if phoneNum.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Please enter Phone Number")
            return
        }
    }
}
extension UIView {
    func phoneDropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

