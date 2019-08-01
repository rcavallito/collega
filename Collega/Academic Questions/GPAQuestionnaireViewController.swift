//
//  GPAQuestionnaireViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 6/27/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class GPAQuestionnaireViewController: UIViewController {

    @IBOutlet weak var gpaInformationTextLabel: UILabel!
    @IBOutlet weak var studentUnweightedGPATextField: UITextField!
    @IBOutlet weak var studentWeightedGPATextField: UITextField!
    @IBOutlet weak var studentScaleGPATextField: UITextField!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                let studentFirstName = (json["StudentFirstName"].stringValue)
                
                self.gpaInformationTextLabel.text = "Terrific \(studentFirstName), now we need to know a little more about your academic situation:"
            }
        })
    }
    
    //Send data to Firebase
    @IBAction func submitGPAInformationPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        let studentGPAInformation = ["StudentUnweightedGPA" : studentUnweightedGPATextField.text!, "StudentWeightedGPA" : studentWeightedGPATextField.text!, "StudentGPAScale" : studentScaleGPATextField.text!] as [String : Any]
        
        ref?.child("Students").child(curUserId).child("StudentGPAInformation").setValue(studentGPAInformation)
        
        performSegue(withIdentifier: "goToSATQuestionnaire", sender: self)
    }
}
