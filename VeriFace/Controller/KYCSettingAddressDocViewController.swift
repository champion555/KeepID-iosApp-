//
//  KYCSettingAddressDocViewController.swift
//  VeriFace
//
//  Created by Admin on 9/4/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class KYCSettingAddressDocViewController: UIViewController {

    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var txtAddressDoc: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imgAddressDoc: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        markView.proofAddressDropShadow()
        configureView()
        let addressDocPath = AppUtils.getValueFromUserDefaults(key: "AddressDocPath")
        if addressDocPath == nil {
            imgAddressDoc.image = UIImage(named: "ic_address_doc")
            txtAddressDoc.text = "Capture Address Document"
        }else {
            let url = URL(string: addressDocPath!)
            if url != nil {
                if let imgData = try? Data(contentsOf: url!) {
                    let image = UIImage(data: imgData)
                    imgAddressDoc.image = image
                    txtAddressDoc.text = "Edit Address Document"
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCProfileSettingViewController") as! KYCProfileSettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onCapture(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddressDocCameraViewController") as! AddressDocCameraViewController
        vc.IdType = "AddressDoc"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onSave(_ sender: Any) {
        AppUtils.savetoUserDefaults(value: "isSaved", key: "AddressDocSaved")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCProfileSettingViewController") as! KYCProfileSettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension UIView {
    func proofAddressDropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
