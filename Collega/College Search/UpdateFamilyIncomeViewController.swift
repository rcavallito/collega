//
//  UpdateFamilyIncomeViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 8/8/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class UpdateFamilyIncomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var updateHouseholdIncomePickerView: UIPickerView!
    let updatedHouseholdIncomeArray = ["-Select One-", "<$30,000", "$30,001 - $48,000", "$48,001 - $75,000", "$75,000 - $110,000", ">$110,000"]
    var updatedHouseholdIncome = ""
    var currentHouseholdIncome = ""
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                
                self.currentHouseholdIncome = (json["StudentFamilyInformation"]["HouseholdIncome"].stringValue)
                
            //Sets inital value of Picker to Current Family Income
                if self.currentHouseholdIncome == "<$30,000" {
                self.updateHouseholdIncomePickerView.selectRow(1, inComponent: 0, animated: true)
                } else if self.currentHouseholdIncome == "$30,001 - $48,000" {
                self.updateHouseholdIncomePickerView.selectRow(2, inComponent: 0, animated: true)
                } else if self.currentHouseholdIncome == "$48,001 - $75,000" {
                self.updateHouseholdIncomePickerView.selectRow(3, inComponent: 0, animated: true)
                } else if self.currentHouseholdIncome == "$75,000 - $110,000" {
                self.updateHouseholdIncomePickerView.selectRow(4, inComponent: 0, animated: true)
                } else if self.currentHouseholdIncome == ">$110,000" {
                self.updateHouseholdIncomePickerView.selectRow(5, inComponent: 0, animated: true)
                } else {
                self.updateHouseholdIncomePickerView.selectRow(0, inComponent: 0, animated: true)
                        }
            }
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return updatedHouseholdIncomeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return updatedHouseholdIncomeArray[row]
    }
    
    
    // This is for when we take the data selected and do something with it:
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        
            updatedHouseholdIncome = updatedHouseholdIncomeArray[row]
        
        }

    @IBAction func submitUpdateFamilyIncomePressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        //trying to get the original value in if no change is made
        if currentHouseholdIncome != updatedHouseholdIncome {
            let familyInformation = ["HouseholdIncome" : updatedHouseholdIncome] as [String : Any]
            ref?.child("Students").child(curUserId).child("StudentFamilyInformation").updateChildValues(familyInformation)
        } else {
            let familyInformation = ["HouseholdIncome" : currentHouseholdIncome] as [String : Any]
            ref?.child("Students").child(curUserId).child("StudentFamilyInformation").updateChildValues(familyInformation)
        }
        
        navigationController?.popViewController(animated: true)
        
        //DELETE AFTER TESTING - This is only necessary when testing in situations where App is started before Nav Controller
        self.dismiss(animated: true, completion: nil)
    }
}
