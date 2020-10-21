//
//  KYCEmailSendViewController.swift
//  VeriFace
//
//  Created by Admin on 8/31/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import KVNProgress
class KYCEmailSendViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var email: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    func configureView(){
        btnVerify.layer.cornerRadius = 5
        btnCancel.layer.cornerRadius = 5
    }

    @IBAction func onVerify(_ sender: Any) {
        email = txtEmail.text!
        if email.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Warning", msg: "Please enter email")
            return
        } else if !CommonManager.shared.isValidEmail(testStr: email) {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Invalid Email")
            return
        }
        AuthenticationToServer()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCEmailVeriViewController") as! KYCEmailVeriViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func AuthenticationToServer(){
        KVNProgress.show(withStatus: "sending code to email...", on: view)
        authentication(urlPart: Constants.URLPart.authentificate.rawValue, apiKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.APIKey.rawValue) ?? Constants.Domain.api_key, secretKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.SecretKey.rawValue) ?? Constants.Domain.secret_key, completion: {error, response in
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "User Email Sending Error", msg: "Server is not working now. please try later")
                KVNProgress.dismiss()
            }else{
                let res = response as! [String: Any]
                let api_access_token = res["api_access_token"] as! String
                self.sendMailToServer(token: api_access_token)
            }
            
        })
    }
    private func sendMailToServer(token : String){
        let language = "en"
        sendMail(urlPart: Constants.URLPart.sendMailOtp.rawValue, token: token,language: language,email: email, completion: { error, response in
        KVNProgress.dismiss()
        if error != nil {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Send Email error", msg: "Please try again")
        } else {
            let res = response as! [String: Any]
            let statusCode = res["statusCode"] as! String
            let jobId = res["job_id"] as! String
            if statusCode == "200"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCEmailVeriViewController") as! KYCEmailVeriViewController
                vc.email = self.email
                vc.jobId = jobId
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                CommonManager.shared.showAlert(viewCtrl: self, title: "Sending Email is failed", msg: "Please try again")
            }
        }
        })
    }
}
