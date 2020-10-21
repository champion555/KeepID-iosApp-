//
//  KYCProfileMainViewController.swift
//  VeriFace
//
//  Created by Admin on 8/31/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class KYCProfileMainViewController: UIViewController {
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnSet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    func configureView(){
        btnVerify.layer.cornerRadius = 5
        btnSet.layer.cornerRadius = 5
    }

    @IBAction func onVerify(_ sender: Any) {
        
    }
    @IBAction func onSetProfile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCProfileSettingViewController") as! KYCProfileSettingViewController
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KYCSettingIDViewController") as! KYCSettingIDViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
