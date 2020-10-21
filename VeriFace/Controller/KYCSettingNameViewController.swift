//
//  KYCSettingNameViewController.swift
//  VeriFace
//
//  Created by Admin on 9/1/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class KYCSettingNameViewController: UIViewController {
    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        markView.nameDropShadow()
        configureView()
        let firstName = AppUtils.getValueFromUserDefaults(key: "firstName")
        let lastName = AppUtils.getValueFromUserDefaults(key: "lastName")
        if firstName != nil{
            txtFirstName.text = firstName
        }
        if lastName != nil {
            txtLastName.text = lastName
        }
    }
    func configureView(){
        btnSave.layer.cornerRadius = 10
        contentView.cornerRadius = 10
        markView.cornerRadius = 50
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onSave(_ sender: Any) {
        let firstName = txtFirstName.text!
        let lastName = txtLastName.text!
        if firstName.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Please enter First Name")
            return
        }
        if lastName.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Please enter Last Name")
            return
        }
        AppUtils.savetoUserDefaults(value: firstName, key: "firstName")
        AppUtils.savetoUserDefaults(value: lastName, key: "lastName")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCProfileSettingViewController") as! KYCProfileSettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension UIView {
    func nameDropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
