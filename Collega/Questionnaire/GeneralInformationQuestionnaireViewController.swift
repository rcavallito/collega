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

    @IBOutlet weak var studentSexPickerView: UIPickerView!
    @IBOutlet weak var studentHomeZipCodeTextField: UITextField!
    @IBOutlet weak var studentStatePickerView: UIPickerView!
    @IBOutlet weak var studentExpectedGraduationYearPickerView: UIPickerView!
    
    //Creating variable for Firebase calls
    var ref:DatabaseReference?
    
    //For the studentStatePickerView
    var studentHomeState = ""
    let studentHomeStateArray = ["-Select One-","AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","PR","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]
    
    //For the studentSexPickerView
    let studentSexArray = ["-Select One-", "Male", "Female", "Genderqueer/Non-Binary", "Rather Not Say"]
    var studentSex = ""
    
    //For the studentExpectedGraduationYearPickerView
    let studentGraduationYearArray = ["2020","2021","2022","2023","2024","Not sure","Another year"]
    var studentGraduationYear = ""
    
    //Pulling first and last name from User Defaults
    let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String
    let studentLastName = UserDefaults.standard.object(forKey: "studentLastName") as? String
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(studentLastName)
        print(studentFirstName)
        
        //Firebase
        ref = Database.database().reference()
    
        studentHomeZipCodeTextField.delegate = self

        //Listen for keyboard events - Original
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    
    //These are standard UIPicker View functions adapted for 3 Picker Views using Tags
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return studentSexArray.count
        } else if pickerView.tag == 2 {
            return studentHomeStateArray.count
        } else {
            return studentGraduationYearArray.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return studentSexArray[row]
        } else  if pickerView.tag == 2 {
            return studentHomeStateArray[row]
        } else {
            return studentGraduationYearArray[row]
        }
    }
    
    //This is where we take the data selected and assign it to a variable
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            studentSex = studentSexArray[row]
        } else if pickerView.tag == 2 {
            studentHomeState = studentHomeStateArray[row]
        } else {
            studentGraduationYear = studentGraduationYearArray[row]
        }
    }
    
    //Stop listening for keyboard events - Original
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //Objective-C function for moving text field - Original
    @objc func keyboardWillChange(notification: Notification) {
        if studentHomeZipCodeTextField.isEditing {
            view.frame.origin.y = -250
        } else {
            view.frame.origin.y = 0
        }
    }
    
    //Allows user to toggle to next Text field or execute function by hitting Enter/Go on keyboard, then dismisses keyboard when done editing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == studentHomeZipCodeTextField {
            textField.resignFirstResponder()
            sendGeneralInformationToFirebase()
        }
        return true
    }
    
    
    //This is where we send data to Firebase
    @IBAction func submitStudentGeneralInformationPressed(_ sender: UIButton) {
        sendGeneralInformationToFirebase()
    }
    
    func sendGeneralInformationToFirebase() {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        guard let curUserEmail = Auth.auth().currentUser?.email else { return }
        
        //Checking to ensure that all the fields have been updated in order to satisfy "StudentGeneralInformationSectionCompleted as True || False
        if curUserEmail != "" && studentHomeState != "" && studentHomeZipCodeTextField.text != "" && studentGraduationYear != "" && studentSex != "" {
        
        let studentInformation = ["StudentEmailAddress" : curUserEmail, "StudentFirstName" : studentFirstName, "StudentLastName" : studentLastName, "StudentHomeState" : studentHomeState,
            "StudentHomeZipCode" : studentHomeZipCodeTextField.text!, "StudentGraduationYear" : studentGraduationYear, "StudentSex" : studentSex, "StudentGeneralInformationSectionCompleted" : "true"] as [String : Any]
            ref?.child("Students").child(curUserId).setValue(studentInformation)
            
        } else {
            
            let studentInformation = ["StudentEmailAddress" : curUserEmail, "StudentFirstName" : studentFirstName, "StudentLastName" : studentLastName, "StudentHomeState" : studentHomeState,
                "StudentHomeZipCode" : studentHomeZipCodeTextField.text!, "StudentGraduationYear" : studentGraduationYear, "StudentSex" : studentSex, "StudentGeneralInformationSectionCompleted" : "false"] as [String : Any]
            ref?.child("Students").child(curUserId).setValue(studentInformation)
        }
        
        performSegue(withIdentifier : "goToEthnicityQuestionnaireScreen", sender: self)
        
    }
    
}
