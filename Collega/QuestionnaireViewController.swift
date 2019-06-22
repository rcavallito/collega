//
//  QuestionnaireViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 5/17/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase

class QuestionnaireViewController: UIViewController {

    @IBOutlet weak var studentFirstNameTextField: UITextField!
    @IBOutlet weak var studentLastNameTextField: UITextField!
    @IBOutlet weak var studentHomeZipCodeTextField: UITextField!
    @IBOutlet weak var studentExpectedGraduationYearTextField: UITextField!
    
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
    }
    
    
    //This is where we send data to Firebase
    
    @IBAction func submitFirstPageQuestionnaireButtonPressed(_ sender: UIButton) {
        
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        guard let curUserEmail = Auth.auth().currentUser?.email else { return }
        
        let studentInformation = ["StudentEmailAddress" : curUserEmail, "StudentFirstName" : studentFirstNameTextField.text!, "StudentLastName" : studentLastNameTextField.text!, "StudentHomeZipCode" : studentHomeZipCodeTextField.text!, "StudentGraduationYear" : studentExpectedGraduationYearTextField.text!] as [String : Any]
        
        ref?.child("Students").child(curUserId).setValue(studentInformation)
        
        //performSegue(withIdentifier : "goToQuestionnaire2", sender: self)
    }
    
}
