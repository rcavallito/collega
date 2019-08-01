//
//  ACTPlansViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 7/5/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class ACTPlansViewController: UIViewController {

    @IBOutlet weak var planOnTakingACTTextLabel: UILabel!
    
    var ref:DatabaseReference?
    var planOnTakingACT : String = "false"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //The opening sentence which calls the Student's first name from Firebase
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                let studentFirstName = (json["StudentFirstName"].stringValue)
                
                self.planOnTakingACTTextLabel.text = "Are you planning on taking the ACT, \(studentFirstName)?"
            }
        })
    }
    
    //Determine if the student plans on taking the SAT
    
    @IBAction func planOnTakingACTSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            planOnTakingACT = "true"
        }
        else {
            planOnTakingACT = "false"
        }
    }
    
    //This is for the "Why are you asking ... "
    @IBAction func whyAskingFromACTPlansQuestionnaire(_ sender: UIButton) {
        performSegue(withIdentifier: "whyAskingFromACTPlansQuestionnaire", sender: self)
    }
    
    //Help me decide
    @IBAction func helpMeDecideFromACTPlans(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAboutSATACTFromACTPlans", sender: self)
    }
    
    
    //Submits the student's answer to Firebase and takes them to the next appropriate screen
    @IBAction func submitPlanOnTakingACTPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
    ref?.child("Students").child(curUserId).child("StudentACTInformation").updateChildValues(["PlanOnTakingACT" : planOnTakingACT, "PlanOnTakingACTTimeStamp" : ServerValue.timestamp()])
        
                if planOnTakingACT == "true" {
                    performSegue(withIdentifier: "goToFinishedFromPlanningOnTakingACT", sender: self)
                } else {
                    performSegue(withIdentifier: "goToAboutSATACTFromACTPlans", sender: self)
                }
    }
}
