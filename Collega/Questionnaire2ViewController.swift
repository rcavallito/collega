//
//  Questionnaire2ViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 5/28/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase

class Questionnaire2ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    @IBOutlet weak var studentSexPickerView: UIPickerView!
    
    let studentSexArray = ["Male", "Female", "Genderqueer/Non-Binary", "Rather Not Say"]
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        
        studentSexPickerView.delegate = self
        studentSexPickerView.dataSource = self
        
    }
    
    //This is for the UIPicker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return studentSexArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return studentSexArray[row]
    }
    
    //This is for when we take the data selected and do something with it:
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(studentSexArray[row])
    }
    
    
    //This is where we send data to Firebase
    
    
    @IBAction func submitStudentSexQuestionnairePressed(_ sender: UIButton) {
        
    
        let studentSex = ["StudentID" : Auth.auth().currentUser!.email!,  "StudentSex" : studentSexPickerView.selectedRow(inComponent: 0)] as [String : Any]
        
        //ref?.child("Students").child("StudentInformation").childByAutoId().setValue(studentInformation)
        ref?.child("Students").child("StudentSex").childByAutoId().setValue(studentSex)
    }
    
}
