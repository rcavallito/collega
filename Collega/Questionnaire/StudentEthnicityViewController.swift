//
//  StudentEthnicityViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 6/20/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class StudentEthnicityViewController: UIViewController {
    
    var whiteEthnicity : String = "false"
    var hispanicEthnicity : String = "false"
    var blackEthnicity : String = "false"
    var asianEthnicity : String = "false"
    var americanIndianEthnicity : String = "false"
    var middleEasternEthnicity : String = "false"
    var nativeHawaiianEthnicity : String = "false"
    var otherEthnicity : String = "false"
    @IBOutlet weak var ethnicityInformationTextLabel: UILabel!
    
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
        
        
//Originally had each instance of using the name as a call into Firebase, but have switched to UserDefaults ...
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let value = snapshot.value {
//                let json = JSON(value)
//                let studentFirstName = (json["StudentFirstName"].stringValue)
        
        //This is the use of NSUserDefaults stored from the prior VC
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.ethnicityInformationTextLabel.text = "\(studentFirstName), which category or categories best describe you (you can select more than one):"
        }
        
        
            }
//        })
//    }
    
    //This is for the "Why are you asking ... "
    @IBAction func whyAskingFromEthnicity(_ sender: UIButton) {
        performSegue(withIdentifier: "whyAskingFromEthnicityQuestionnaire", sender: self)
    }
    
    //Send the data to Firebase
    @IBAction func submitStudentEthnicityPressed(_ sender: UIButton) {
        
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        let studentEthnicity = ["White" : whiteEthnicity, "HispanicLatinoSpanish" : hispanicEthnicity, "BlackAfricanAmerican" : blackEthnicity, "Asian" : asianEthnicity, "AmericanIndianAlaskaNative" : americanIndianEthnicity, "MiddleEasternNorthAfrican" : middleEasternEthnicity, "NativeHawaiianOtherPacific" : nativeHawaiianEthnicity, "Other" : otherEthnicity] as [String : Any]
        
        ref?.child("Students").child(curUserId).child("StudentEthnicityInformation").setValue(studentEthnicity)
        
        performSegue(withIdentifier: "goToFamilyQuestionnaire", sender: self)
    }

}
