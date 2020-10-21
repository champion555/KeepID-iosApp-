//
//  Constants.swift
//  VeriVoice
//
//  Created by Raza Ali on 27/06/2020.
//  Copyright © 2020 Raza Ali. All rights reserved.
//

import Foundation
class Constants {
    static var datePickerDate: String!
    static var FrontIDDocPath = ""
    static var BackIDDocPath = ""
    
    
    struct Domain {
        static let BASEURL = "http://109.238.12.179:5000/v1/api"
        static let api_key = "Mzc0MTExMjUtNTBmMS00ZTA3LWEwNjktZjQxM2UwNjA3ZGEw"
        static let secret_key = "YTE4YmM5YmYtZjZhYS00MTU5LWI4Y2EtYjQyYTRkNzAxOWZj"
        static let user_name = "demo_app"
    }
    enum AppPrefrenace : String {
        case ClientID
        case AppUrl
        case RecordTime
        case SampleRate
        case APIKey
        case SecretKey
        case UserName
    }        
    enum URLPart : String {
        case authentificate = "/client/authentificate"
        case photoLivenessCheck = "/photoFaceLiveness"
        case videoLivenessCheck = "/videoFaceLiveness"
        case enrollementCheck = "/faceEnroll"
        case authenticationCheck = "/facePhotoVerif"
        case userEnrolledCheck = "/userEnrolledCheck"
        case sendMailOtp = "/sendMailOtp"
        case checkMailOtp = "/checkMailOtp"
        case sendSMSOtp = "/sendSMSOtp"
        case checkSMSOtp = "/checkSMSOtp"
        case IDVerify = "/idDocVerif"
        case imageQualityCheck = "/ImageQualityCheck"
    }
    
}
