//
//  KYCPhoneSendViewController.swift
//  VeriFace
//
//  Created by Admin on 9/22/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import NKVPhonePicker
import KVNProgress
class KYCPhoneSendViewController: UIViewController {
    @IBOutlet weak var txtPhoneNumber: NKVPhonePickerTextField!
    @IBOutlet weak var btnVerification: UIButton!
    var phoneNum: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnVerification.layer.cornerRadius = 10
        txtPhoneNumber.phonePickerDelegate = self
    }
    @IBAction func onVerification(_ sender: Any) {
        phoneNum = "+" + txtPhoneNumber.text
        if phoneNum.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Warning", msg: "Please enter Phone Number")
            return
        }
        AuthenticationToServer()
    }
    @IBAction func onCancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func AuthenticationToServer(){
        KVNProgress.show(withStatus: "sending code to phone...", on: view)
        authentication(urlPart: Constants.URLPart.authentificate.rawValue, apiKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.APIKey.rawValue) ?? Constants.Domain.api_key, secretKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.SecretKey.rawValue) ?? Constants.Domain.secret_key, completion: {error, response in
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "The code sending to phone error", msg: "Server is not working now. please try later")
                KVNProgress.dismiss()
            }else{
                let res = response as! [String: Any]
                let api_access_token = res["api_access_token"] as! String
                self.sendPhoneToServer(token: api_access_token)
            }
            
        })
    }
    private func sendPhoneToServer(token : String){
        let language = "en"
        sendPhoneNum(urlPart: Constants.URLPart.sendSMSOtp.rawValue, token: token,language: language,phone:phoneNum, completion: { error, response in
        KVNProgress.dismiss()
        if error != nil {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Send Phone error", msg: "Please try again")
        } else {
            let res = response as! [String: Any]
            let statusCode = res["statusCode"] as! String
            let jobId = res["job_id"] as! String
            if statusCode == "200"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCPhoneVeriViewController") as! KYCPhoneVeriViewController
                vc.phoneNum = self.phoneNum
                vc.jobId = jobId
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                CommonManager.shared.showAlert(viewCtrl: self, title: "Sending Phone is failed", msg: "Please try again")
            }
        }
        })
    }

}
