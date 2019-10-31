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
    
    //Variables describing students' possibile ethnicities, all defaulted to "false"
    var whiteEthnicity : String = "False"
    var hispanicEthnicity : String = "False"
    var blackEthnicity : String = "False"
    var asianEthnicity : String = "False"
    var americanIndianEthnicity : String = "False"
    var middleEasternEthnicity : String = "False"
    var nativeHawaiianEthnicity : String = "False"
    var otherEthnicity : String = "False"
    
    @IBOutlet weak var ethnicityInformationTextLabel: UILabel!
    
    //Defines what happens if/when a switch is changed (default is "false")
    @IBAction func whiteEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            whiteEthnicity = "True"
        }
        else {
            whiteEthnicity = "False"
        }
    }
    
    @IBAction func hispanicEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            hispanicEthnicity = "True"
        }
        else {
            hispanicEthnicity = "False"
        }
    }
    
    @IBAction func blackEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            blackEthnicity = "True"
        }
        else {
            blackEthnicity = "False"
        }
    }
    
    @IBAction func asianEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            asianEthnicity = "True"
        }
        else {
            asianEthnicity = "False"
        }
    }
    
    @IBAction func americanIndianEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            americanIndianEthnicity = "True"
        }
        else {
            americanIndianEthnicity = "False"
        }
    }
    
    @IBAction func middleEasternEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            middleEasternEthnicity = "True"
        }
        else {
            middleEasternEthnicity = "False"
        }
    }
    
    @IBAction func hawaiianPacificEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            nativeHawaiianEthnicity = "True"
        }
        else {
            nativeHawaiianEthnicity = "False"
        }
    }
    
    @IBAction func otherEthnicitySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            otherEthnicity = "True"
        }
        else {
            otherEthnicity = "False"
        }
    }
    
    //Creating variable for Firebase calls
    var ref:DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase
        ref = Database.database().reference()
        
        //Dynamic content allowing for personalization of First Name from User Defaults
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.ethnicityInformationTextLabel.text = "\(studentFirstName), which category or categories best describe you (you can select more than one):"
        }
    }

    //This is for the "Why are you asking ... "
    @IBAction func whyAskingFromEthnicity(_ sender: UIButton) {
        performSegue(withIdentifier: "whyAskingFromEthnicityQuestionnaire", sender: self)
        
        
    }
    
    //Send the data to Firebase
    @IBAction func submitStudentEthnicityPressed(_ sender: UIButton) {
                
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        //Checking to ensure that all the fields have been updated in order to satisfy "StudentEthnicityInformationSectionCompleted as True || False
        if whiteEthnicity == "false" && hispanicEthnicity == "false" && blackEthnicity == "false" && asianEthnicity == "false" && americanIndianEthnicity == "false" && middleEasternEthnicity == "false" && nativeHawaiianEthnicity == "false" && otherEthnicity == "false" {
        
            let studentEthnicity = ["White" : whiteEthnicity, "HispanicLatinoSpanish" : hispanicEthnicity, "BlackAfricanAmerican" : blackEthnicity, "Asian" : asianEthnicity, "AmericanIndianAlaskaNative" : americanIndianEthnicity, "MiddleEasternNorthAfrican" : middleEasternEthnicity, "NativeHawaiianOtherPacific" : nativeHawaiianEthnicity, "Other" : otherEthnicity, "StudentEthnicityInformationSectionCompleted" : "false"] as [String : Any]
            ref?.child("Students").child(curUserId).child("StudentEthnicityInformation").setValue(studentEthnicity)
            
        } else {
            
            let studentEthnicity = ["White" : whiteEthnicity, "HispanicLatinoSpanish" : hispanicEthnicity, "BlackAfricanAmerican" : blackEthnicity, "Asian" : asianEthnicity, "AmericanIndianAlaskaNative" : americanIndianEthnicity, "MiddleEasternNorthAfrican" : middleEasternEthnicity, "NativeHawaiianOtherPacific" : nativeHawaiianEthnicity, "Other" : otherEthnicity, "StudentEthnicityInformationSectionCompleted" : "true"] as [String : Any]
            ref?.child("Students").child(curUserId).child("StudentEthnicityInformation").setValue(studentEthnicity)
        }
        
        performSegue(withIdentifier: "goToFamilyQuestionnaire", sender: self)
        
    }

}
