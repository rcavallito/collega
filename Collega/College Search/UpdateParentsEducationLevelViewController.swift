//
//  UpdateParentsEducationLevelViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 8/9/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class UpdateParentsEducationLevelViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var updateParentsEducationLevelPickerView: UIPickerView!
    let updatedParentsEducationLevelArray = ["-Select One-", "Both parents graduated college", "One parent graduated college", "Both parents some college", "One parent some college", "Neither parent graduated college"]
    var updatedParentsEducationLevel = ""
    var currentParentsEducationLevel = ""
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                
                self.currentParentsEducationLevel = (json["StudentFamilyInformation"]["ParentsEducationLevel"].stringValue)
                
                print(self.currentParentsEducationLevel)
                
                //Sets inital value of Picker to Current Family Income
                if self.currentParentsEducationLevel == "Both parents graduated college" {
                    self.updateParentsEducationLevelPickerView.selectRow(1, inComponent: 0, animated: true)
                } else if self.currentParentsEducationLevel == "One parent graduated college" {
                    self.updateParentsEducationLevelPickerView.selectRow(2, inComponent: 0, animated: true)
                } else if self.currentParentsEducationLevel == "Both parents some college" {
                    self.updateParentsEducationLevelPickerView.selectRow(3, inComponent: 0, animated: true)
                } else if self.currentParentsEducationLevel == "One parent some college" {
                    self.updateParentsEducationLevelPickerView.selectRow(4, inComponent: 0, animated: true)
                } else if self.currentParentsEducationLevel == "Neither parent graduated college" {
                    self.updateParentsEducationLevelPickerView.selectRow(5, inComponent: 0, animated: true)
                } else {
                    self.updateParentsEducationLevelPickerView.selectRow(0, inComponent: 0, animated: true)
                }
            }
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return updatedParentsEducationLevelArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return updatedParentsEducationLevelArray[row]
    }
    
    
    // This is for when we take the data selected and do something with it:
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updatedParentsEducationLevel = updatedParentsEducationLevelArray[row]
    }
    
    @IBAction func submitUpdateParentsEducationLevelPressed(_ sender: UIButton) {
    
    guard let curUserId = Auth.auth().currentUser?.uid else { return }
    
    let parentsEducationLevel = ["ParentsEducationLevel" : updatedParentsEducationLevel] as [String : Any]
    ref?.child("Students").child(curUserId).child("StudentFamilyInformation").updateChildValues(parentsEducationLevel)
    
    navigationController?.popViewController(animated: true)
    
    //DELETE AFTER TESTING - This is only necessary when testing in situations where App is started before Nav Controller
    self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
