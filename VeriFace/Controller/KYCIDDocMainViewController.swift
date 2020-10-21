//
//  KYCIDDocMainViewController.swift
//  VeriFace
//
//  Created by Admin on 9/4/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class KYCIDDocMainViewController: UIViewController {
    @IBOutlet weak var imgMark: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        imgMark.idDocMainDropShadow()
    }
    func configureView(){
        imgMark.layer.cornerRadius = 50
    }
    @IBAction func onBack(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCProfileSettingViewController") as! KYCProfileSettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onPassport(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCSettingPassportViewController") as! KYCSettingPassportViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onIDCard(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCSettingIDCardViewController") as! KYCSettingIDCardViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onDrivingLicense(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCSettingDrivingViewController") as! KYCSettingDrivingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onResidentPermit(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCSettingResidentViewController") as! KYCSettingResidentViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
extension UIView {
    func idDocMainDropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
