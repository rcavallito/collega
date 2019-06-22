//
//  Questionnaire2ViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 5/28/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class Questionnaire2ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var additionalInformationTextLabel: UILabel!
    @IBOutlet weak var studentSexPickerView: UIPickerView!
    
    let studentSexArray = ["Male", "Female", "Genderqueer/Non-Binary", "Rather Not Say"]
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                let studentFirstName = (json["StudentFirstName"].stringValue)
                
                self.additionalInformationTextLabel.text = "Terrific \(studentFirstName), now let's move on to some additional questions that will help us find the best fit for you:"
        
            }
            
        })
        
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
        
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
    ref?.child("Students").child(curUserId).child("StudentSex").setValue(studentSexPickerView.selectedRow(inComponent: 0))
        
        //performSegue(withIdentifier: "goToQuestionnaire3", sender: self)
        
    }
}
