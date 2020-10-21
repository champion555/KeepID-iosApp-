//
//  KYCProfileSettingViewController.swift
//  VeriFace
//
//  Created by Admin on 9/1/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class KYCProfileSettingViewController: UIViewController {
    @IBOutlet var uiViews:[UIView]!
    @IBOutlet weak var imgNameMark: UIImageView!
    @IBOutlet weak var imgNameIcon: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    
    @IBOutlet weak var imgEmailMark: UIImageView!
    @IBOutlet weak var imgEmailIcon: UIImageView!
    @IBOutlet weak var txtEmail: UILabel!
    
    @IBOutlet weak var imgAddressMark: UIImageView!
    @IBOutlet weak var imgAddressIcon: UIImageView!
    @IBOutlet weak var txtAddress: UILabel!
    
    @IBOutlet weak var imgPhoneMark: UIImageView!
    @IBOutlet weak var imgPhoneIcon: UIImageView!
    @IBOutlet weak var txtPhone: UILabel!
    
    @IBOutlet weak var imgIDDocMark: UIImageView!
    @IBOutlet weak var imgIDDocIcon: UIImageView!
    @IBOutlet weak var txtIDDoc: UILabel!
    
    @IBOutlet weak var imgBirthMark: UIImageView!
    @IBOutlet weak var imgBirthIcon: UIImageView!
    @IBOutlet weak var txtBirth: UILabel!
    
    @IBOutlet weak var imgProofAddressMark: UIImageView!
    @IBOutlet weak var imgProofAddressIcon: UIImageView!
    @IBOutlet weak var txtProofAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        let firstName = AppUtils.getValueFromUserDefaults(key: "firstName")
        let lastName = AppUtils.getValueFromUserDefaults(key: "lastName")
        let countryName = AppUtils.getValueFromUserDefaults(key: "countryName")
        let city  = AppUtils.getValueFromUserDefaults(key: "city")
        let birth = AppUtils.getValueFromUserDefaults(key: "birthday")
        let passportSaved = AppUtils.getValueFromUserDefaults(key: "PassportSaved")
        let idCardSaved = AppUtils.getValueFromUserDefaults(key: "IDCardSaved")
        let drivingSaved = AppUtils.getValueFromUserDefaults(key: "DrivingSaved")
        let residentSaved = AppUtils.getValueFromUserDefaults(key: "ResidentSaved")
        let addressDocPath = AppUtils.getValueFromUserDefaults(key: "AddressDocPath")
        let userEmail = AppUtils.getValueFromUserDefaults(key: "UserEmail")
        let userPhone = AppUtils.getValueFromUserDefaults(key: "UserPhone")
        if firstName  == nil{
            imgNameMark.image = UIImage(named: "ic_failed")
            imgNameIcon.image = UIImage(named: "ic_name_gray")
        }else{
            imgNameMark.image = UIImage(named: "ic_verify")
            imgNameIcon.image = UIImage(named: "ic_name_purple")
            txtName.text = firstName! + "" + lastName!
        }
        if passportSaved == nil || idCardSaved == nil || drivingSaved == nil || residentSaved == nil {
            imgIDDocMark.image = UIImage(named: "ic_failed")
            imgIDDocIcon.image = UIImage(named: "ic_identity_gray")
            txtIDDoc.text = "The Documents aren't added."
        }else{
            if UserDefaults.standard.bool(forKey: "passportVerify") == true && UserDefaults.standard.bool(forKey: "idCardVerify") == true && UserDefaults.standard.bool(forKey: "drivingVerify") == true && UserDefaults.standard.bool(forKey: "residentVerify") == true{
                imgIDDocMark.image = UIImage(named: "ic_success")
                imgIDDocIcon.image = UIImage(named: "ic_identity_purple")
                txtIDDoc.text = "The Documents are verified successfully."
                
            }else{
                imgIDDocMark.image = UIImage(named: "ic_verify")
                imgIDDocIcon.image = UIImage(named: "ic_identity_purple")
                txtIDDoc.text = "The Documents are added successfully."
            }
        }
        if countryName == nil {
            imgAddressMark.image = UIImage(named: "ic_failed")
            imgAddressIcon.image = UIImage(named: "ic_address_gray")
        }else{
            imgAddressMark.image = UIImage(named: "ic_verify")
            imgAddressIcon.image = UIImage(named: "ic_address_purple")
            txtAddress.text = city! + "/" + countryName!
        }
        if birth == nil{
            imgBirthMark.image = UIImage(named: "ic_failed")
            imgBirthIcon.image = UIImage(named: "ic_birthday_gray")
        }else {
            imgBirthMark.image = UIImage(named: "ic_verify")
            imgBirthIcon.image = UIImage(named: "ic_birth_purple")
            txtBirth.text = birth!
        }
        if addressDocPath == nil{
            imgProofAddressMark.image = UIImage(named: "ic_failed")
            imgProofAddressIcon.image = UIImage(named: "ic_addressproof_gray")
            txtProofAddress.text = "The Document was not added."
        }else{
            imgProofAddressMark.image = UIImage(named: "ic_verify")
            imgProofAddressIcon.image = UIImage(named: "ic_addressproof_purple")
            txtProofAddress.text = "The Document was added successfully."
        }
        if userEmail == nil{
            imgEmailMark.image = UIImage(named: "ic_failed")
            imgEmailIcon.image = UIImage(named: "ic_email_gray")
        }else{
            if UserDefaults.standard.bool(forKey: "emailVerify") == true{
                imgEmailMark.image = UIImage(named: "ic_success")
                imgEmailIcon.image = UIImage(named: "ic_email_purple")
                txtEmail.text = userEmail
            }else{
                imgEmailMark.image = UIImage(named: "ic_verify")
                imgEmailIcon.image = UIImage(named: "ic_email_purple")
                txtEmail.text = userEmail
            }
            
        }
        if userPhone == nil{
            imgPhoneMark.image = UIImage(named: "ic_failed")
            imgPhoneIcon.image = UIImage(named: "ic_phone_gray")
        }else{
            if UserDefaults.standard.bool(forKey: "phoneVerify") == true{
                imgPhoneMark.image = UIImage(named: "ic_success")
                imgPhoneIcon.image = UIImage(named: "ic_phone_purple")
                txtPhone.text = userPhone
            }else{
                imgPhoneMark.image = UIImage(named: "ic_verify")
                imgPhoneIcon.image = UIImage(named: "ic_phone_purple")
                txtPhone.text = userPhone
            }
            
        }
    }
    func configureView(){
        for viewItem in uiViews{
            viewItem.layer.borderWidth = 1
            viewItem.layer.borderColor = UIColor.black.cgColor
            viewItem.layer.cornerRadius = 15
        }
    }
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onName(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCSettingNameViewController") as! KYCSettingNameViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onAddress(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCSettingAddressViewController") as! KYCSettingAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onPhone(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCSettingPhoneViewController") as! KYCSettingPhoneViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onIDDoc(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCIDDocMainViewController") as! KYCIDDocMainViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onBirth(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCSettingBirthViewController") as! KYCSettingBirthViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onProofAddress(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCSettingAddressDocViewController") as! KYCSettingAddressDocViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
