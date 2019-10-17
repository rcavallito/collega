//
//  FamilyHistoryViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 6/24/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class FamilyHistoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var familyInformationTextLabel: UILabel!
    @IBOutlet weak var parentsEducationLevelPickerView: UIPickerView!
    @IBOutlet weak var householdIncomePickerView: UIPickerView!
    
    //Arrays and variables for Picker Views
    let parentsEducationLevelArray = ["-Select One-", "Both parents graduated college", "One parent graduated college", "Both parents some college", "One parent some college", "Neither parent graduated college","I don't know", "I don't want to answer"]
    let householdIncomeArray = ["-Select One-", "<$30,000", "$30,001 - $48,000", "$48,001 - $75,000", "$75,000 - $110,000", ">$110,000","I don't know", "I don't want to answer"]
    var parentsEducationLevel = ""
    var householdIncome = ""
    
    //Creating variable for Firebase calls
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase
        ref = Database.database().reference()
        
        //Dynamic content allowing for personalization of First Name from User Defaults
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.familyInformationTextLabel.text = "Alright \(studentFirstName), now we need to ask you some questions about your family:"
        }
    }

    //These are standard UIPicker View functions adapted for 2 Picker Views using Tags
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return parentsEducationLevelArray.count
        } else {
            return householdIncomeArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return parentsEducationLevelArray[row]
        } else {
            return householdIncomeArray[row]
        }
    }
    
    //This is where we take the data selected and assign it to a variable
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
        parentsEducationLevel = parentsEducationLevelArray[row]
        print(parentsEducationLevel)
        } else {
        householdIncome = householdIncomeArray[row]
        print(householdIncome)
        }
    }
        
    //This is for the "Why are you asking ... "
    @IBAction func whyAskingFromFamilyQuestionnaire(_ sender: UIButton) {
        performSegue(withIdentifier: "whyAskingFromFamilyQuestionnaire", sender: self)
    }

    //Send data to Firebase
    @IBAction func submitFamilyInformationPressed(_ sender: UIButton) {
        
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        //Checking to ensure that all the fields have been updated in order to satisfy "StudentFamilyInformationSectionCompleted" as True || False
        if parentsEducationLevel == "" || householdIncome == "" {
        
            let familyInformation = ["ParentsEducationLevel" : parentsEducationLevel, "HouseholdIncome" : householdIncome, "StudentFamilyInformationSectionCompleted" : "false"] as [String : Any]
            ref?.child("Students").child(curUserId).child("StudentFamilyInformation").setValue(familyInformation)
            
        } else {
            
            let familyInformation = ["ParentsEducationLevel" : parentsEducationLevel, "HouseholdIncome" : householdIncome, "StudentFamilyInformationSectionCompleted" : "true"] as [String : Any]
            ref?.child("Students").child(curUserId).child("StudentFamilyInformation").setValue(familyInformation)
        }

        performSegue(withIdentifier: "goToGPAQuestionnaireScreen", sender: self)
        
    }

}
