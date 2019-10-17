//
//  ACTQuestionnaireViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 7/5/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class ACTQuestionnaireViewController: UIViewController {
    
    //IBOutlets for the various text labels
    @IBOutlet weak var actInformationTextLabel: UILabel!
    @IBOutlet weak var pactInformationTextLabel: UILabel!
    @IBOutlet weak var questionTakingACTTextLabel: UILabel!
    
    //Creating variable for Firebase calls
    var ref:DatabaseReference?
    
    //Creating variables for the UISwitch's
    var takenACT : String = "false"
    var takenPACT : String = "false"
    var planOnTakingACT : String = "false"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase
        ref = Database.database().reference()
        
        //Dynamic content allowing for personalization of First Name from User Defaults
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.actInformationTextLabel.text = "Have you taken the ACT, \(studentFirstName)?"
        }
    }
    
    //Determine if the student has taken the ACT yet
    @IBAction func takenACTSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            takenACT = "true"
        }
        else {
            takenACT = "false"
        }
    }
    
    //Determine if the student has taken the PACT yet
    @IBAction func takenPACTSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            takenPACT = "true"
        }
        else {
            takenPACT = "false"
        }
    }
    
    //Determine if the student is going to take the ACT
    @IBAction func planOnTakingACTSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            planOnTakingACT = "true"
        }
        else {
            planOnTakingACT = "false"
        }
    }
    
    
    //This is for the "Why are you asking ... "
    @IBAction func whyAskingFromACTQuestionnaire(_ sender: UIButton) {
        performSegue(withIdentifier: "whyAskingFromACTQuestionnaire", sender: self)
    }
    
    //Submits the student's answer to Firebase and takes them to the next appropriate screen
    @IBAction func submitACTTakenPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
    ref?.child("Students").child(curUserId).child("StudentACTInformation").setValue(["TakenACT" : takenACT, "TakenPACT" : takenPACT, "PlanOnTakingACT" : planOnTakingACT, "SATQuestionnaireTimeStamp" : ServerValue.timestamp()])
        
        if takenACT == "true" || takenPACT == "true" {
            performSegue(withIdentifier: "goToACTScoresQuestionnaire", sender: self)
        } else {
            performSegue(withIdentifier: "goToTakingSATOrACTInformation", sender: self)
        }
    }
}
