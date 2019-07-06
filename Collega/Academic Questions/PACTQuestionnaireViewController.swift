//
//  PACTQuestionnaireViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 7/5/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class PACTQuestionnaireViewController: UIViewController {
    
    @IBOutlet weak var pactInformationTextLabel: UILabel!
    
    var ref:DatabaseReference?
    var takenPACT : String = "false"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //The opening sentence which calls the Student's first name from Firebase
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                let studentFirstName = (json["StudentFirstName"].stringValue)
                
                self.pactInformationTextLabel.text = "Have you taken the PreACT, \(studentFirstName)?"
            }
        })
    }
    
    //Determine if the student has taken the PreACT yet
    @IBAction func takenPACTSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            takenPACT = "true"
        }
        else {
            takenPACT = "false"
        }
    }
    
    //Submits the student's answer to Firebase and takes them to the next appropriate screen
    @IBAction func submitPACTTakenPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        ref?.child("Students").child(curUserId).child("StudentACTInformation").updateChildValues(["TakenPACT" : takenPACT, "TakenPACTTimeStamp" : ServerValue.timestamp()])
        
        if takenPACT == "true" {
            performSegue(withIdentifier: "goToACTScoresFromPACTQuestionnaire", sender: self)
        } else {
            performSegue(withIdentifier: "goToTakingACTQuestionnaire", sender: self)
        }
    }
}
