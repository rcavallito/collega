//
//  WelcomeBackViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 6/24/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class WelcomeBackViewController: UIViewController {

    @IBOutlet weak var welcomeBackTextLabel: UILabel!
    
    var ref:DatabaseReference?
    var studentGraduationYear = ""
    var studentSex = ""
    var studentEthnicity = ""
    var studentFamilyInformation = ""
    var studentGPA = ""
    var studentSAT = ""
    var studentACT = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                self.studentGraduationYear = (json["StudentGraduationYear"].stringValue)
                self.studentSex = (json["StudentSex"].stringValue)
                self.studentEthnicity = (json["StudentEthnicityInformation"]["AmericanIndianAlaskaNative"].stringValue)
                self.studentFamilyInformation = (json["StudentFamilyInformation"]["ParentsEducationLevel"].stringValue)
                self.studentGPA = (json["StudentGPAInformation"]["StudentUnweightedGPA"].stringValue)
                self.studentSAT = (json["StudentSATInformation"]["StudentMathSATScore"].stringValue)
                self.studentACT = (json["StudentACTInformation"]["StudentMathACTScore"].stringValue)
            }
        })
    }
    
    @IBAction func letsFindACollegeFromWelcomeScreen(_ sender: UIButton) {
        performSegue(withIdentifier: "welcomeScreenToFindACollege", sender: self)
    }
    
    @IBAction func returnToQuestionnaireFromWelcomeScreen(_ sender: UIButton) {
        if studentGraduationYear == "" {
            performSegue(withIdentifier: "resumeQuestionnaireGeneralInformation", sender: self)
        } else if studentSex == "" || studentSex == "skipped" {
            performSegue(withIdentifier: "resumeQuestionnaireSex", sender: self)
        } else if studentEthnicity == "" || studentEthnicity == "skipped" {
            performSegue(withIdentifier: "resumeQuestionnaireEthnicity", sender: self)
        } else if studentFamilyInformation == "" {
            performSegue(withIdentifier: "resumeQuestionnaireFamily", sender: self)
        } else if studentGPA == "" {
            performSegue(withIdentifier: "resumeQuestionnaireGPA", sender: self)
        } else if studentSAT == "" {
            performSegue(withIdentifier: "resumeQuestionnaireSATScores", sender: self)
        } else if studentACT == "" {
            performSegue(withIdentifier: "resumeQuestionnaireACTScores", sender: self)
        } else {
            performSegue(withIdentifier: "resumeQuestionnaireFinished", sender: self)
        }
    }
}
