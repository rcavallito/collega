//
//  PSATQuestionnaireViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 7/1/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class PSATQuestionnaireViewController: UIViewController {
    
    @IBOutlet weak var psatInformationTextLabel: UILabel!
    
    var ref:DatabaseReference?
    var takenPSAT : String = "false"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //The opening sentence which calls the Student's first name from Firebase
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                let studentFirstName = (json["StudentFirstName"].stringValue)
                
                self.psatInformationTextLabel.text = "Have you taken the PSAT, \(studentFirstName)?"
            }
        })
    }
    
    //Determine if the student has taken the PSAT yet
    @IBAction func takenPSATSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            takenPSAT = "true"
        }
        else {
            takenPSAT = "false"
        }
    }
    
    //This is for the "Why are you asking ... "
    @IBAction func whyAskingFromPSATQuestionnaire(_ sender: UIButton) {
        performSegue(withIdentifier: "whyAskingFromPSATQuestionnaire", sender: self)
    }
    
    //Submits the student's answer to Firebase and takes them to the next appropriate screen
    @IBAction func submitPSATTakenPressed(_ sender: UIButton) {
    
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        //New code that allows for timestamp and sets TakenSAT as value under StudentSATInformation as opposed to original which sets it as a child
        ref?.child("Students").child(curUserId).child("StudentSATInformation").updateChildValues(["TakenPSAT" : takenPSAT, "TakenPSATTimeStamp" : ServerValue.timestamp()])
        
        if takenPSAT == "true" {
            performSegue(withIdentifier: "goToSATScoresFromPSATQuestionnaire", sender: self)
        } else {
            performSegue(withIdentifier: "goToTakingSATQuestionnaire", sender: self)
        }
    }
}

