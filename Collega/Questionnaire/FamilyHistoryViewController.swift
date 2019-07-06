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
    
    let parentsEducationLevelArray = ["-Select One-", "Both parents graduated college", "One parent graduated college", "Both parents some college", "One parent some college", "Neither parent graduated college"]
    let householdIncomeArray = ["-Select One-", "<$25,000", "$25,001 - $45,000", "$45,001 - $75,000", "$75,000 - $115,000", ">$115,000"]
    var parentsEducationLevel = ""
    var householdIncome = ""
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parentsEducationLevelPickerView.delegate = self
        parentsEducationLevelPickerView.dataSource = self

        householdIncomePickerView.delegate = self
        householdIncomePickerView.dataSource = self
        
//        self.parentsEducationLevelPickerView.selectRow(0, inComponent: 0, animated: true)
//        self.householdIncomePickerView.selectRow(0, inComponent: 0, animated: true)
        
        ref = Database.database().reference()

        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                let studentFirstName = (json["StudentFirstName"].stringValue)

                self.familyInformationTextLabel.text = "\(studentFirstName), now we need to ask you some questions about your family:"

                    }

                })
    
    }

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
    
// This is for when we take the data selected and do something with it:
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
        parentsEducationLevel = parentsEducationLevelArray[row]
        print(parentsEducationLevel)
        } else {
        householdIncome = householdIncomeArray[row]
        print(householdIncome)
        }
    }

    
// This is where we send data to Firebase
    
    @IBAction func submitFamilyInformationPressed(_ sender: UIButton) {

        guard let curUserId = Auth.auth().currentUser?.uid else { return }

        let familyInformation = ["ParentsEducationLevel" : parentsEducationLevel, "HouseholdIncome" : householdIncome] as [String : Any]
        
        
//        let familyInformation = ["ParentsEducationLevel" : parentsEducationLevelPickerView.selectedRow(inComponent: 0), "HouseholdIncome" : householdIncomePickerView.selectedRow(inComponent: 0)] as [String : Any]
        ref?.child("Students").child(curUserId).child("StudentFamilyInformation").setValue(familyInformation)

        performSegue(withIdentifier: "goToGPAQuestionnaireScreen", sender: self)
        
    }

}
