//
//  Questionnaire3ViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 6/20/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase

class Questionnaire3ViewController: UIViewController {
    
    var whiteEthnicity : String = "false"
    var hispanicEthnicity : String = "false"
    var blackEthnicity : String = "false"
    var asianEthnicity : String = "false"
    var americanIndianEthnicity : String = "false"
    var middleEasternEthnicity : String = "false"
    var nativeHawaiianEthnicity : String = "false"
    var otherEthnicity : String = "false"
    
    @IBAction func whiteEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            whiteEthnicity = "true"
        }
        else {
            whiteEthnicity = "false"
        }
    }
    
    @IBAction func hispanicEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            hispanicEthnicity = "true"
        }
        else {
            hispanicEthnicity = "false"
        }
    }
    
    @IBAction func blackEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            blackEthnicity = "true"
        }
        else {
            blackEthnicity = "false"
        }
    }
    
    @IBAction func asianEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            asianEthnicity = "true"
        }
        else {
            asianEthnicity = "false"
        }
    }
    
    @IBAction func americanIndianEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            americanIndianEthnicity = "true"
        }
        else {
            americanIndianEthnicity = "false"
        }
    }
    
    @IBAction func middleEasternEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            middleEasternEthnicity = "true"
        }
        else {
            middleEasternEthnicity = "false"
        }
    }
    
    
    @IBAction func hawaiianPacificEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            nativeHawaiianEthnicity = "true"
        }
        else {
            nativeHawaiianEthnicity = "false"
        }
    }
    
    @IBAction func otherEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            otherEthnicity = "true"
        }
        else {
            otherEthnicity = "false"
        }
    }
    
    
    var ref:DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

    }
    
    //Send the data to Firebase

    @IBAction func submitStudentEthnicityPressed(_ sender: UIButton) {
        
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        let studentEthnicity = ["White" : whiteEthnicity, "HispanicLatinoSpanish" : hispanicEthnicity, "BlackAfricanAmerican" : blackEthnicity, "Asian" : asianEthnicity, "AmericanIndianAlaskaNative" : americanIndianEthnicity, "MiddleEasternNorthAfrican" : middleEasternEthnicity, "NativeHawaiianOtherPacific" : nativeHawaiianEthnicity, "Other" : otherEthnicity] as [String : Any]
        
        ref?.child("Students").child(curUserId).child("StudentEthnicity").setValue(studentEthnicity)
    }

}
