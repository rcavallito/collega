//
//  GeneralInformationQuestionnaireViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 5/17/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase

class GeneralInformationQuestionnaireViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var studentFirstNameTextField: UITextField!
    @IBOutlet weak var studentLastNameTextField: UITextField!
    @IBOutlet weak var studentHomeZipCodeTextField: UITextField!
    @IBOutlet weak var studentStatePickerView: UIPickerView!
    @IBOutlet weak var studentExpectedGraduationYearTextField: UITextField!
    
    var ref:DatabaseReference?
    
    var studentState = ""
    let stateArray = ["-Select One-","AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","PR","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentStatePickerView.delegate = self
        studentStatePickerView.dataSource = self
        
        ref = Database.database().reference()
        studentExpectedGraduationYearTextField.delegate = self
        studentHomeZipCodeTextField.delegate = self
        studentLastNameTextField.delegate = self
        studentFirstNameTextField.delegate = self
        
        //Listen for keyboard events - Original
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //This is for the UIPicker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateArray[row]
    }
    
    //This is where we take the data selected and put it into an array
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(stateArray[row])
        studentState = stateArray[row]
    }
    
    //Stop listening for keyboard events - Original
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //Objective-C function for moving text field - Original
    @objc func keyboardWillChange(notification: Notification) {
        if studentExpectedGraduationYearTextField.isEditing || studentHomeZipCodeTextField.isEditing {
            view.frame.origin.y = -250
        } else {
            view.frame.origin.y = 0
        }
    }
    
    //This is where we send data to Firebase
    @IBAction func submitStudentGeneralInformationPressed(_ sender: UIButton) {
        sendGeneralInformationToFirebase()
    }
    
    //Allows user to toggle to next Text field or execute function by hitting Enter/Go on keyboard, then dismisses keyboard when done editing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == studentFirstNameTextField {
            textField.resignFirstResponder()
            studentLastNameTextField.becomeFirstResponder()
        } else if textField == studentLastNameTextField {
            textField.resignFirstResponder()
            studentHomeZipCodeTextField.becomeFirstResponder()
        } else if textField == studentHomeZipCodeTextField {
            textField.resignFirstResponder()
            studentExpectedGraduationYearTextField.becomeFirstResponder()
        } else if textField == studentExpectedGraduationYearTextField {
            textField.resignFirstResponder()
            sendGeneralInformationToFirebase()
        }
        return true
    }
    
    func sendGeneralInformationToFirebase() {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        guard let curUserEmail = Auth.auth().currentUser?.email else { return }
        
        let studentInformation = ["StudentEmailAddress" : curUserEmail, "StudentFirstName" : studentFirstNameTextField.text!, "StudentLastName" : studentLastNameTextField.text!, "StudentHomeState" : studentState,
            "StudentHomeZipCode" : studentHomeZipCodeTextField.text!, "StudentGraduationYear" : studentExpectedGraduationYearTextField.text!] as [String : Any]
                
        ref?.child("Students").child(curUserId).setValue(studentInformation)
        
        performSegue(withIdentifier : "goToSexQuestionnaireScreen", sender: self)
    }
    
}
