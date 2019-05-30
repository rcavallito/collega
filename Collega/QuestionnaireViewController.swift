//
//  QuestionnaireViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 5/17/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase

class QuestionnaireViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var studentFirstNameTextField: UITextField!
    @IBOutlet weak var studentLastNameTextField: UITextField!
    @IBOutlet weak var studentHomeZipCodeTextField: UITextField!
    @IBOutlet weak var studentExpectedGraduationYearPicker: UIPickerView!
    
    let graduationYearArray = ["2020", "2021", "2022", "2023", "2024"]
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        
        studentExpectedGraduationYearPicker.delegate = self
        studentExpectedGraduationYearPicker.dataSource = self
        
    }
    
    //This is for the UIPicker View

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return graduationYearArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return graduationYearArray[row]
    }
    
    //This is for when we take the data selected and do something with it:
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(graduationYearArray[row])
    }
    
    
    //This is where we send data to Firebase
    
    @IBAction func submitFirstPageQuestionnaireButtonPressed(_ sender: UIButton) {
    
        //need to fid GraduationYearPicker to send actual graduation year to the database and not the corresponding interger
        let studentInformation = ["StudentID" : Auth.auth().currentUser!.email!, "StudentFirstName" : studentFirstNameTextField.text!, "StudentLastName" : studentLastNameTextField.text!, "StudentHomeZipCode" : studentHomeZipCodeTextField.text!, "StudentGraduationYear" : studentExpectedGraduationYearPicker.selectedRow(inComponent: 0)] as [String : Any]
        
        //ref?.child("Students").child("StudentInformation").childByAutoId().setValue(studentInformation)
        ref?.child("Students").child("StudentInformation").childByAutoId().setValue(studentInformation)
    }
    
}
