//
//  KYCSettingResidentViewController.swift
//  VeriFace
//
//  Created by Admin on 9/19/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import KVNProgress
class KYCSettingResidentViewController: UIViewController {

    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgFrontResident: UIImageView!
    @IBOutlet weak var lblFrontText: UILabel!
    @IBOutlet weak var imgBackResident: UIImageView!
    @IBOutlet weak var lblBackText: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    var mergedIDCardUri: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        markView.DrivingDropShadow()
        configureView()
        let frontResidentPath = AppUtils.getValueFromUserDefaults(key: "ResidentFrontPath")
        let backResidentPath = AppUtils.getValueFromUserDefaults(key: "ResidentBackPath")
        if frontResidentPath == nil {
            imgFrontResident.image = UIImage(named: "ic_idcard_front")
            lblFrontText.text = "Capture Front of Resident Permit"
        }else {
            let url = URL(string: frontResidentPath!)
            if url != nil {
                if let imgData = try? Data(contentsOf: url!) {
                    let image = UIImage(data: imgData)
                    imgFrontResident.image = image
                    lblFrontText.text = "Edit Front of Resident Permit"
                }
            }
        }
        if backResidentPath == nil {
            imgBackResident.image = UIImage(named: "ic_idcard_back")
            lblBackText.text = "Capture Back of Resident Permit"
        }else {
            let url = URL(string: backResidentPath!)
            if url != nil {
                if let imgData = try? Data(contentsOf: url!) {
                    let image = UIImage(data: imgData)
                    imgBackResident.image = image
                    lblBackText.text = "Edit Back of Resident Permit"
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
    
    @IBAction func onFrontCapture(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        vc.IdType = "FrontResident"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onBackCapture(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        vc.IdType = "BackResident"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onSave(_ sender: Any) {
        AppUtils.savetoUserDefaults(value: "isSaved", key: "ResidentSaved")
        mergeImage()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCIDDocMainViewController") as! KYCIDDocMainViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func mergeImage(){
        let topImage = imgFrontResident.image
        let bottomImage = imgBackResident.image
        let size = CGSize(width: topImage!.size.width, height: topImage!.size.height + bottomImage!.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        topImage?.draw(in: CGRect(x: 0, y: 0, width:size.width, height: size.height/2))
        bottomImage?.draw(in: CGRect(x:0, y: size.height/2, width:size.width, height: size.height/2))
        let mergedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "IDCardMergedIamge.jpg"
        mergedIDCardUri = documentsDirectory.appendingPathComponent(fileName)
        let data = mergedImage.jpegData(compressionQuality:  1.0)
        if !FileManager.default.fileExists(atPath: mergedIDCardUri.path) {
            do {
                try data!.write(to: mergedIDCardUri)
                print("file saved")
                self.AuthenticationToServer()
               
            } catch {
                print("error saving file:", error)
            }
        }else{
            do {
                try FileManager.default.removeItem(at: mergedIDCardUri)
                print("Remove successfully")
                do {
                    try data!.write(to: mergedIDCardUri)
                    print("file saved")
                    self.AuthenticationToServer()
                } catch {
                    print("error saving file:", error)
                }
            }
            catch let error as NSError {
                print("error deleting file:", error)
            }
        }
        
        
    }
    func AuthenticationToServer(){
        KVNProgress.show(withStatus: "Verify Resident Permit...", on: view)
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
        IDDocVerification(urlPart: Constants.URLPart.IDVerify.rawValue, token: token, IDDocPath: mergedIDCardUri, completion: { error, response in
            KVNProgress.dismiss()
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "Error", msg: "ID Card verification is failed. please try again")
            }else{
                let res = response as! [String: Any]
                let status = res["status"] as! String
                if status == "SUCCESS"{
                    let IDDocRes = IDDocVeriResponse(dict: res)
                    UserDefaults.standard.set(true, forKey: "residentVerify")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDDocVeriResultViewController") as! IDDocVeriResultViewController
                    vc.IDDocType = "ID Card"
                    vc.response = IDDocRes
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    CommonManager.shared.showAlert(viewCtrl: self, title: "Error", msg: "Bad input MRZ image!. please try again")
                    
                }
                
            }
        })
    }

}
extension UIView {
    func ResidentDropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
