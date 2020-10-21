//
//  KYCSettingPassportViewController.swift
//  VeriFace
//
//  Created by Admin on 9/19/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import KVNProgress
class KYCSettingPassportViewController: UIViewController {

    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgPassport: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    var passportUri:URL!
    var passportPath: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        markView.PassportDropShadow()
        configureView()
//        let passportPath = UserDefaults.standard.string(forKey: "PassportPath")
        passportPath = AppUtils.getValueFromUserDefaults(key: "PassportPath")
        if passportPath == nil {
            imgPassport.image = UIImage(named: "ic_passport")
            lblText.text = "Capture the Passport"
        }else {
            let url = URL(string: passportPath!)
            if url != nil {
                if let imgData = try? Data(contentsOf: url!) {
                    let image = UIImage(data: imgData)
                    imgPassport.image = image
                    lblText.text = "Edit Passport"
                }
            }
        }
    }
    func configureView(){
        contentView.cornerRadius = 10
        markView.cornerRadius = 50
        btnSave.layer.cornerRadius = 10
    }
    @IBAction func onBack(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCIDDocMainViewController") as! KYCIDDocMainViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onPassportCapture(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        vc.IdType = "Passport"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onSave(_ sender: Any) {
        AppUtils.savetoUserDefaults(value: "isSaved", key: "PassportSaved")
        AuthenticationToServer()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCIDDocMainViewController") as! KYCIDDocMainViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    func AuthenticationToServer(){
        KVNProgress.show(withStatus: "Verify passport...", on: view)
        authentication(urlPart: Constants.URLPart.authentificate.rawValue, apiKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.APIKey.rawValue) ?? Constants.Domain.api_key, secretKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.SecretKey.rawValue) ?? Constants.Domain.secret_key, completion: {error, response in
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "User Enrolled Checking Error", msg: "Server is not working now. please try later")
                KVNProgress.dismiss()
            }else{
                let res = response as! [String: Any]
                let api_access_token = res["api_access_token"] as! String
                self.verifyIDDocToServer(token: api_access_token)
            }
            
        })
    }
    private func verifyIDDocToServer(token : String){
        passportUri = NSURL(string: passportPath) as URL?
        IDDocVerification(urlPart: Constants.URLPart.IDVerify.rawValue, token: token, IDDocPath: passportUri, completion: { error, response in
            KVNProgress.dismiss()
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "Error", msg: "Passport verification is failed. please try again")
            }else{
                let res = response as! [String: Any]
                let status = res["status"] as! String
                if status == "SUCCESS"{
                    let IDDocRes = IDDocVeriResponse(dict: res)
                    UserDefaults.standard.set(true, forKey: "passportVerify")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDDocVeriResultViewController") as! IDDocVeriResultViewController
                    vc.IDDocType = "Passport"
                    vc.response = IDDocRes
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    CommonManager.shared.showAlert(viewCtrl: self, title: "Error", msg: "Bad input MRZ image!")
                }
                
            }
        })
    }
}
extension UIView {
    func PassportDropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
