//
//  KYCLoginViewController.swift
//  VeriFace
//
//  Created by Admin on 9/4/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class KYCLoginViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var btnLoginPIN: UIButton!
    @IBOutlet weak var txtCode1: UITextField!
    @IBOutlet weak var txtCode2: UITextField!
    @IBOutlet weak var txtCode3: UITextField!
    @IBOutlet weak var txtCode4: UITextField!
    @IBOutlet weak var txtCode5: UITextField!
    @IBOutlet weak var txtCode6: UITextField!
    var isHide: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

    }
    func configureView(){
        btnLoginPIN.layer.cornerRadius = 5
        
        txtCode1.backgroundColor = UIColor.clear
        txtCode2.backgroundColor = UIColor.clear
        txtCode3.backgroundColor = UIColor.clear
        txtCode4.backgroundColor = UIColor.clear
        txtCode5.backgroundColor = UIColor.clear
        txtCode6.backgroundColor = UIColor.clear
        
        addRectBorderTo(textField: txtCode1)
        addRectBorderTo(textField: txtCode2)
        addRectBorderTo(textField: txtCode3)
        addRectBorderTo(textField: txtCode4)
        addRectBorderTo(textField: txtCode5)
        addRectBorderTo(textField: txtCode6)
        
        txtCode1.delegate = self
        txtCode2.delegate = self
        txtCode3.delegate = self
        txtCode4.delegate = self
        txtCode5.delegate = self
        txtCode6.delegate = self
    }
    func addRectBorderTo(textField:UITextField) {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1).cgColor
        layer.frame = CGRect(x: 0.0, y: textField.frame.size.height - 2.0, width: textField.frame.size.width, height: 2.0)
        textField.layer.addSublayer(layer)
    }
    func addWaringRectBorderTo(textField:UITextField) {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor
        layer.frame = CGRect(x: 0.0, y: 0.0, width: textField.frame.size.width, height: textField.frame.size.height)
        textField.layer.addSublayer(layer)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count)! < 1 ) && (string.count > 0) {
            if textField == txtCode1 {
                txtCode2.becomeFirstResponder()
            }
            
            if textField == txtCode2 {
                txtCode3.becomeFirstResponder()
            }
            
            if textField == txtCode3 {
                txtCode4.becomeFirstResponder()
            }
            
            if textField == txtCode4 {
                txtCode5.becomeFirstResponder()
            }
            if textField == txtCode5 {
                txtCode6.becomeFirstResponder()
            }
            if textField == txtCode6 {
                txtCode6.resignFirstResponder()
            }
            textField.text = string
            print(string)
            return false
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == txtCode2 {
                txtCode1.becomeFirstResponder()
            }
            if textField == txtCode3 {
                txtCode2.becomeFirstResponder()
            }
            if textField == txtCode4 {
                txtCode3.becomeFirstResponder()
            }
            if textField == txtCode5 {
                txtCode4.becomeFirstResponder()
            }
            if textField == txtCode6 {
                txtCode5.becomeFirstResponder()
            }
            if textField == txtCode1 {
                txtCode1.resignFirstResponder()
            }
            textField.text = ""
            return false
        } else if (textField.text?.count)! >= 1 {
            textField.text = string
            return false
        }
        
        return true
    }
    
    @IBAction func onShow(_ sender: Any) {
        if isHide == false{
            imgShow.image = UIImage(named: "ic_hide")
            txtCode1.isSecureTextEntry = false
            txtCode2.isSecureTextEntry = false
            txtCode3.isSecureTextEntry = false
            txtCode4.isSecureTextEntry = false
            txtCode5.isSecureTextEntry = false
            txtCode6.isSecureTextEntry = false
            
            isHide = true
        }else{
            imgShow.image = UIImage(named: "ic_show")
            txtCode1.isSecureTextEntry = true
            txtCode2.isSecureTextEntry = true
            txtCode3.isSecureTextEntry = true
            txtCode4.isSecureTextEntry = true
            txtCode5.isSecureTextEntry = true
            txtCode6.isSecureTextEntry = true
            isHide = false
        }
    }
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onUnlock(_ sender: Any) {
        let code1 = txtCode1.text
        let code2 = txtCode2.text
        let code3 = txtCode3.text
        let code4 = txtCode4.text
        let code5 = txtCode5.text
        let code6 = txtCode6.text
        let unlockOtpCode = code1! + code2! + code3! + code4! + code5! + code6!
        let createdPinCode = AppUtils.getValueFromUserDefaults(key: "CreatedPinCode")
        if unlockOtpCode == createdPinCode{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCProfileMainViewController") as! KYCProfileMainViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            CommonManager.shared.showAlert(viewCtrl: self, title: "Unlock pin error", msg: "Please retry to unlock with Pin code")
        }
        
    }
}
