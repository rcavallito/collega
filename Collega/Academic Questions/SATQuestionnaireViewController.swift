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
    
    //IBOutlets for the various text labels
    @IBOutlet weak var satInformationTextLabel: UILabel!
    @IBOutlet weak var psatInformationTextLabel: UILabel!
    @IBOutlet weak var questionTakingSATTextLabel: UILabel!
    
    //Creating variable for Firebase calls
    var ref:DatabaseReference?
    
    //Creating variables for the UISwitch's
    var takenSAT : String = "false"
    var takenPSAT : String = "false"
    var planOnTakingSAT : String = "false"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase
        ref = Database.database().reference()
        
        //Dynamic content allowing for personalization of First Name from User Defaults
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.satInformationTextLabel.text = "Have you taken the SAT, \(studentFirstName)?"
            
            self.psatInformationTextLabel.text = "If not, have you taken the PSAT?"
            
            self.questionTakingSATTextLabel.text = "If you haven't taken either, are you planning on taking the SAT?"
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
    
    //Determine if the student has taken the PSAT yet
    @IBAction func takenPSATSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
                takenPSAT = "true"
            }
            else {
                takenPSAT = "false"
            }
        }
    
    //Determine if the student is going to take the SAT
    @IBAction func planOnTakingSATSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            planOnTakingSAT = "true"
        }
        else {
            planOnTakingSAT = "false"
        }
    }
    
    //This is for the "Why are you asking ... "
    @IBAction func whyAskingFromSATQuestionnaire(_ sender: UIButton) {
        performSegue(withIdentifier: "whyAskingFromSATQuestionnaire", sender: self)
    }
    
    
    //Submits the student's answer to Firebase and takes them to the next appropriate screen
    @IBAction func submitSATTakenPressed(_ sender: UIButton) {
        
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
   
        
        //Checking to ensure that all the fields have been updated in order to satisfy "StudentGPAInformationSectionCompleted" as True || False
//        if takenSAT == "" && takenPSAT == "" && planOnTakingSAT == "" {
//
//            let studentSATQuestionnaireInformation = ["TakenSAT" : takenSAT, "TakenPSAT" : takenPSAT, "PlanOnTakingSAT" : planOnTakingSAT, "SATQuestionnaireTimeStamp" : ServerValue.timestamp(), "StudentSATQuestionnaireSATInformationCompleted" : "false"] as [String : Any]
//            ref?.child("Students").child(curUserId).child("StudentSATInformation").setValue(studentSATQuestionnaireInformation)
//
//               } else {
//
//                let studentSATQuestionnaireInformation = ["TakenSAT" : takenSAT, "TakenPSAT" : takenPSAT, "PlanOnTakingSAT" : planOnTakingSAT, "SATQuestionnaireTimeStamp" : ServerValue.timestamp(), "StudentSATQuestionnaireSATInformationCompleted" : "true"] as [String : Any]
//                ref?.child("Students").child(curUserId).child("StudentSATInformation").setValue(studentSATQuestionnaireInformation)
//               }
    ref?.child("Students").child(curUserId).child("StudentSATInformation").setValue(["TakenSAT" : takenSAT, "TakenPSAT" : takenPSAT, "PlanOnTakingSAT" : planOnTakingSAT, "SATQuestionnaireTimeStamp" : ServerValue.timestamp()])
        
        //Need to come up with a way to check if this section is completed, but take into account that student might simply answer "false" to all questions - HOW ABOUT SETTING DEFAULT VAR TO "" INSTEAD OF "FALSE"??? Doesn't work because if they leave it at default instead of selecting "no"...
        
        if takenSAT == "true" || takenPSAT == "true" {
            performSegue(withIdentifier: "goToSATScoresQuestionnaire", sender: self)
        } else {
            performSegue(withIdentifier: "goToACTQuestionnaireFromSATQuestionnaire", sender: self)
        }
    }
}
