//
//  UpdateStudentSexViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 8/9/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class UpdateStudentSexViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var updateStudentSexPickerView: UIPickerView!
    
    let updatedStudentSexArray = ["-Select One-", "Male", "Female", "Genderqueer/Non-Binary", "Rather Not Say"]
    
    var updatedStudentSex = ""
    var currentStudentSex = ""
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                self.currentStudentSex = (json["StudentSex"].stringValue)
                
            //Sets inital value of Picker to Current Family Income
            if self.currentStudentSex == "Male" {
            self.updateStudentSexPickerView.selectRow(1, inComponent: 0, animated: true)
            } else if self.currentStudentSex == "Female" {
            self.updateStudentSexPickerView.selectRow(2, inComponent: 0, animated: true)
            } else if self.currentStudentSex == "Genderqueer/Non-Binary" {
            self.updateStudentSexPickerView.selectRow(3, inComponent: 0, animated: true)
            } else if self.currentStudentSex == "Rather Not Say" {
            self.updateStudentSexPickerView.selectRow(4, inComponent: 0, animated: true)
            } else {
            self.updateStudentSexPickerView.selectRow(0, inComponent: 0, animated: true)
            }
                
            }
        })
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return updatedStudentSexArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return updatedStudentSexArray[row]
    }
    
    
    // This is for when we take the data selected and do something with it:
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            updatedStudentSex = updatedStudentSexArray[row]
        
    }
    
    
    @IBAction func submitUpdateStudentSexPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        let studentSex = ["StudentSex" : updatedStudentSex] as [String : Any]
        ref?.child("Students").child(curUserId).updateChildValues(studentSex)
        
        navigationController?.popViewController(animated: true)
        
        //DELETE AFTER TESTING - This is only necessary when testing in situations where App is started before Nav Controller
        self.dismiss(animated: true, completion: nil)
    }
}
