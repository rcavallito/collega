//
//  SATPlansViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 7/1/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class SATPlansViewController: UIViewController {

    @IBOutlet weak var planOnTakingSATTextLabel: UILabel!
    
    var ref:DatabaseReference?
    var planOnTakingSAT : String = "false"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.planOnTakingSATTextLabel.text = "Are you planning on taking the SAT, \(studentFirstName)?"
        }
    }
    
    //Determine if the student plans on taking the SAT
    @IBAction func planOnTakingSATSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            planOnTakingSAT = "true"
        }
        else {
            planOnTakingSAT = "false"
        }
    }
    
    //This is for the "Why are you asking ... "
    @IBAction func whyAskingFromSATPlansQuestionnaire(_ sender: UIButton) {
        performSegue(withIdentifier: "whyAskingFromPSATQuestionnaire", sender: self)
    }
    
    //Help me decide
    @IBAction func helpMeDecideFromSATPlans(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAboutSATACTFromSATPlans", sender: self)
    }
    
    
    //Submits the student's answer to Firebase and takes them to the next appropriate screen
    @IBAction func submitPlanOnTakingSATPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        //New code that allows for timestamp and sets TakenSAT as value under StudentSATInformation as opposed to original which sets it as a child
        ref?.child("Students").child(curUserId).child("StudentSATInformation").updateChildValues(["PlanOnTakingSAT" : planOnTakingSAT, "PlanOnTakingSATTimeStamp" : ServerValue.timestamp()])
        
            performSegue(withIdentifier: "goToACTQuestionnaireFromSATPlans", sender: self)
    }
}
