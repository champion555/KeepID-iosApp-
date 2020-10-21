//
//  KYCSettingAddressViewController.swift
//  VeriFace
//
//  Created by Admin on 9/4/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import ADCountryPicker
class KYCSettingAddressViewController: UIViewController {
    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtStreet1: UITextField!
    @IBOutlet weak var txtStreet2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtRegion: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCountry: UIButton!
    var flagImage: UIImage!
    var countryName: String!
    var dialingCode: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        markView.addressDropShadow()
        configureView()
        let countryName = AppUtils.getValueFromUserDefaults(key: "countryName")
        let street1 = AppUtils.getValueFromUserDefaults(key: "street1")
        let street2 = AppUtils.getValueFromUserDefaults(key: "street2")
        let city  = AppUtils.getValueFromUserDefaults(key: "city")
        let resion = AppUtils.getValueFromUserDefaults(key: "resion")
        let postCode = AppUtils.getValueFromUserDefaults(key: "postCode")
        if countryName != nil {
            txtCountry.text = countryName
            txtStreet1.text = street1
            txtStreet2.text = street2
            txtCity.text = city
            txtRegion.text = resion
            txtPostCode.text = postCode
        }

    }
    func configureView(){
        contentView.cornerRadius = 10
        markView.cornerRadius = 50
        btnSave.layer.cornerRadius = 10
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onSelectCountry(_ sender: Any) {
        getCountryInfo()
    }
    @IBAction func onSave(_ sender: Any) {
        let countryName = txtCountry.text!
        let street1 = txtStreet1.text!
        let street2 = txtStreet2.text!
        let city = txtCity.text!
        let resion = txtRegion.text!
        let postCode = txtPostCode.text!
        if countryName.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Please select the country")
            return
        }
        if street1.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Please enter Street1")
            return
        }
        if street2.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Please enter Street2")
            return
        }
        if city.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Please enter City")
            return
        }
        if resion.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Please enter Resion/State")
            return
        }
        if postCode.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Please enter PostCode/Zip")
            return
        }
        AppUtils.savetoUserDefaults(value: countryName, key: "countryName")
        AppUtils.savetoUserDefaults(value: street1, key: "street1")
        AppUtils.savetoUserDefaults(value: street2, key: "street2")
        AppUtils.savetoUserDefaults(value: city, key: "city")
        AppUtils.savetoUserDefaults(value: resion, key: "resion")
        AppUtils.savetoUserDefaults(value: postCode, key: "postCode")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCProfileSettingViewController") as! KYCProfileSettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getCountryInfo(){
        let picker = ADCountryPicker(style: .grouped)
        picker.delegate = self
        picker.showCallingCodes = true
        picker.didSelectCountryClosure = { name, code in
            _ = picker.navigationController?.popToRootViewController(animated: true)
            if self.flagImage != nil && self.countryName != nil{
                self.imgFlag.image = self.flagImage
                self.txtCountry.text = self.countryName
            }
        }
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
}
extension UIView {
    func addressDropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension KYCSettingAddressViewController: ADCountryPickerDelegate {
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        self.flagImage  =  picker.getFlag(countryCode: code)
        self.countryName  =  picker.getCountryName(countryCode: code)
        self.dialingCode  =  picker.getDialCode(countryCode: code)

    }
}
