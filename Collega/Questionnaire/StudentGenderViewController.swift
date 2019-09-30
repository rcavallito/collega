//
//  StudentGenderViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 5/28/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class StudentGenderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var additionalInformationTextLabel: UILabel!
    @IBOutlet weak var studentSexPickerView: UIPickerView!
    
    let studentSexArray = ["-Select One-", "Male", "Female", "Genderqueer/Non-Binary", "Rather Not Say"]
    var studentDefinedSex = ""
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.additionalInformationTextLabel.text = "Terrific \(studentFirstName), now let's move on to some additional questions that will help us find the best fit for you:"
        }
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
    
    //This is where we take the data selected and put it into an array
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        studentDefinedSex = studentSexArray[row]
    }
    
    //This is for the "Why are you asking ... "
    @IBAction func whyAskingFromSexVC(_ sender: UIButton) {
        performSegue(withIdentifier: "whyAskingFromSexQuestionnaire", sender: self)
    }
    
    //Send data to Firebase
    @IBAction func submitStudentSexQuestionnairePressed(_ sender: UIButton) {
        
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
    ref?.child("Students").child(curUserId).child("StudentSex").setValue(studentDefinedSex)
        
        performSegue(withIdentifier: "goToEthnicityQuestionnaireScreen", sender: self)
    }
}
