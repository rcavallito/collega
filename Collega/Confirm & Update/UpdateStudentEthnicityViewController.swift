//
//  UpdateStudentEthnicityViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 8/9/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class UpdateStudentEthnicityViewController: UIViewController {

    var updatedWhiteEthnicity : String = "false"
    var updatedHispanicEthnicity : String = "false"
    var updatedBlackEthnicity : String = "false"
    var updatedAsianEthnicity : String = "false"
    var updatedAmericanIndianEthnicity : String = "false"
    var updatedMiddleEasternEthnicity : String = "false"
    var updatedNativeHawaiianEthnicity : String = "false"
    var updatedOtherEthnicity : String = "false"
    
    var ref:DatabaseReference?
    
    @IBOutlet weak var whiteEthnicitySwitch: UISwitch!
    @IBOutlet weak var hispanicLatinoEthnicitySwitch: UISwitch!
    @IBOutlet weak var blackAfricanAmericanEthnicitySwitch: UISwitch!
    @IBOutlet weak var asianEthnicitySwitch: UISwitch!
    @IBOutlet weak var americanIndianEthnicitySwitch: UISwitch!
    @IBOutlet weak var middleEasternEthnicitySwitch: UISwitch!
    @IBOutlet weak var nativeHawaiiPacificIslanderEthnicitySwitch: UISwitch!
    @IBOutlet weak var otherEthnicitySwitch: UISwitch!
    
    
    @IBAction func whiteEthnicitySwitchChanged(_ sender: UISwitch) {
        if (sender.isOn == true) {
            updatedWhiteEthnicity = "true"
        } else {
            updatedWhiteEthnicity = "false"
        }
    }
    
    @IBAction func hispanicLatinoEthnicitySwitchChanged(_ sender: UISwitch) {
        if (sender.isOn == true) {
            updatedHispanicEthnicity = "true"
        } else {
            updatedHispanicEthnicity = "false"
        }
    }
    
    @IBAction func blackAfricanAmericanEthnicitySwitchChanged(_ sender: UISwitch) {
        if (sender.isOn == true) {
            updatedBlackEthnicity = "true"
        } else {
            updatedBlackEthnicity = "false"
        }
    }
    
    @IBAction func asianEthnicitySwitchChanged(_ sender: UISwitch) {
        if (sender.isOn == true) {
            updatedAsianEthnicity = "true"
        } else {
            updatedAsianEthnicity = "false"
        }
    }

    @IBAction func americanIndianEthnicitySwitchChanged(_ sender: UISwitch) {
        if (sender.isOn == true) {
            updatedAmericanIndianEthnicity = "true"
        } else {
            updatedAmericanIndianEthnicity = "false"
        }
    }
    
    @IBAction func middleEasternEthnicitySwitchChanged(_ sender: UISwitch) {
        if (sender.isOn == true) {
            updatedMiddleEasternEthnicity = "true"
        } else {
            updatedMiddleEasternEthnicity = "false"
        }
    }
    
    @IBAction func nativeHawaiiPacificIslanderEthnicitySwitchChanged(_ sender: UISwitch) {
        if (sender.isOn == true) {
            updatedNativeHawaiianEthnicity = "true"
        } else {
            updatedNativeHawaiianEthnicity = "false"
        }
    }
    
    @IBAction func otherEthnicitySwitchChanged(_ sender: UISwitch) {
        if (sender.isOn == true) {
            updatedOtherEthnicity = "true"
        } else {
            updatedOtherEthnicity = "false"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                
            if (json["StudentEthnicityInformation"]["AmericanIndianAlaskaNative"]) == "true" {
                self.americanIndianEthnicitySwitch.setOn(true, animated: true)
            } else {
                self.americanIndianEthnicitySwitch.setOn(false, animated: true)
            }
                
            if (json["StudentEthnicityInformation"]["Asian"]) == "true"{
                self.asianEthnicitySwitch.setOn(true, animated: true)
            } else {
                self.asianEthnicitySwitch.setOn(false, animated: true)
            }
                
            if (json["StudentEthnicityInformation"]["BlackAfricanAmerican"]) == "true" {
                self.blackAfricanAmericanEthnicitySwitch.setOn(true, animated: true)
            } else {
                self.blackAfricanAmericanEthnicitySwitch.setOn(false, animated: true)
                }
                
            if (json["StudentEthnicityInformation"]["HispanicLatinoSpanish"]) == "true" {
                self.hispanicLatinoEthnicitySwitch.setOn(true, animated: true)
            } else {
                self.hispanicLatinoEthnicitySwitch.setOn(false, animated: true)
                }
                
            if (json["StudentEthnicityInformation"]["MiddleEasternNorthAfrican"]) == "true" {
                self.middleEasternEthnicitySwitch.setOn(true, animated: true)
            } else {
                self.middleEasternEthnicitySwitch.setOn(false, animated: true)
                }
                
            if (json["StudentEthnicityInformation"]["NativeHawaiianOtherPacific"]) == "true" {
                self.nativeHawaiiPacificIslanderEthnicitySwitch.setOn(true, animated: true)
            } else {
                self.nativeHawaiiPacificIslanderEthnicitySwitch.setOn(false, animated: true)
                }
                
            if (json["StudentEthnicityInformation"]["White"]) == "true" {
                self.whiteEthnicitySwitch.setOn(true, animated: true)
            } else {
                self.whiteEthnicitySwitch.setOn(false, animated: true)
                }
            
            if (json["StudentEthnicityInformation"]["Other"]) == "true" {
                self.otherEthnicitySwitch.setOn(true, animated: true)
            } else {
                self.otherEthnicitySwitch.setOn(false, animated: true)
                }
        }
        }
    )}
    
    
    @IBAction func submitUpdateStudentEthnicityPressed(_ sender: UIButton) {
    guard let curUserId = Auth.auth().currentUser?.uid else { return }
    
    let updatedStudentEthnicity = ["White" : updatedWhiteEthnicity, "HispanicLatinoSpanish" : updatedHispanicEthnicity, "BlackAfricanAmerican" : updatedBlackEthnicity, "Asian" : updatedAsianEthnicity, "AmericanIndianAlaskaNative" : updatedAmericanIndianEthnicity, "MiddleEasternNorthAfrican" : updatedMiddleEasternEthnicity, "NativeHawaiianOtherPacific" : updatedNativeHawaiianEthnicity, "Other" : updatedOtherEthnicity] as [String : Any]
    
    ref?.child("Students").child(curUserId).child("StudentEthnicityInformation").setValue(updatedStudentEthnicity)
        
        navigationController?.popViewController(animated: true)
        
        //DELETE AFTER TESTING - This is only necessary when testing in situations where App is started before Nav Controller
        self.dismiss(animated: true, completion: nil)
    
    }
}
