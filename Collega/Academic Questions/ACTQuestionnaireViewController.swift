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
    
    @IBOutlet weak var actInformationTextLabel: UILabel!
    
    var ref:DatabaseReference?
    var takenACT : String = "false"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    //This is for the "Why are you asking ... "
    @IBAction func whyAskingFromACTQuestionnaire(_ sender: UIButton) {
        performSegue(withIdentifier: "whyAskingFromACTQuestionnaire", sender: self)
    }
    
    //Submits the student's answer to Firebase and takes them to the next appropriate screen
    @IBAction func submitACTTakenPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        //New code that allows for timestamp and sets TakenACT as value under StudentACTInformation as opposed to original which sets it as a child
        ref?.child("Students").child(curUserId).child("StudentACTInformation").setValue(["TakenACT" : takenACT, "TakenACTTimeStamp" : ServerValue.timestamp()])
        
        if takenACT == "true" {
            performSegue(withIdentifier: "goToACTScoresQuestionnaire", sender: self)
        } else {
            performSegue(withIdentifier: "goToPACTQuestionnaire", sender: self)
        }
    }
}
