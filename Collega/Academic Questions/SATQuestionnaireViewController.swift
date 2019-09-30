//
//  SATQuestionnaireViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 7/1/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class SATQuestionnaireViewController: UIViewController {
    
    @IBOutlet weak var satInformationTextLabel: UILabel!
    
    var ref:DatabaseReference?
    var takenSAT : String = "false"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.satInformationTextLabel.text = "Have you taken the SAT, \(studentFirstName)?"
        }
    }
    
    //Determine if the student has taken the SAT yet
    @IBAction func takenSATSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            takenSAT = "true"
        }
        else {
            takenSAT = "false"
        }
    }
    
    //Submits the student's answer to Firebase and takes them to the next appropriate screen
    @IBAction func submitSATTakenPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
    
   //New code that allows for timestamp and sets TakenSAT as value under StudentSATInformation as opposed to original which sets it as a child
   ref?.child("Students").child(curUserId).child("StudentSATInformation").setValue(["TakenSAT" : takenSAT, "TakenSATTimeStamp" : ServerValue.timestamp()])
        
        if takenSAT == "true" {
            performSegue(withIdentifier: "goToSATScoresQuestionnaire", sender: self)
        } else {
            performSegue(withIdentifier: "goToPSATQuestionnaire", sender: self)
        }
    }
}
