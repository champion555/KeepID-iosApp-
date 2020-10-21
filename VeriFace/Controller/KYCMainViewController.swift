//
//  KYCMainViewController.swift
//  VeriFace
//
//  Created by Admin on 8/31/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class KYCMainViewController: UIViewController {
    @IBOutlet weak var btnCreateID: UIButton!
    @IBOutlet weak var btnRestore: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        if UserDefaults.standard.bool(forKey: "isloggedin") == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCLoginViewController") as! KYCLoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func configureView() {
        btnCreateID.layer.cornerRadius = 10
        btnRestore.layer.cornerRadius = 10
    }
    @IBAction func onCreateID(_ sender: Any) {
//       let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCEmailSendViewController") as! KYCEmailSendViewController
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCCreatePINViewController") as! KYCCreatePINViewController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCProfileSettingViewController") as! KYCProfileSettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onRestore(_ sender: Any) {
    }
    @IBAction func onSetting(_ sender: Any) {
    }
}
