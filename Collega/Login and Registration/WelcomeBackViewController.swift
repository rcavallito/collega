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
    
    //Variables to determine where the student left off in the questionnaire
    var studentGeneralInformationSectionCompleted = "false"
    var studentEthnicityInformationSectionCompleted = "false"
    var studentFamilyInformationSectionCompleted = ""
    var studentGPASectionCompleted = ""
    var studentSATTakenSectionCompleted = ""
    var studentACTTakenSectionCompleted = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                
                //Tests each section if completed to know where to bring student to complete questionnaire
                self.studentGeneralInformationSectionCompleted = (json["StudentGeneralInformationSectionCompleted"].stringValue)
                self.studentEthnicityInformationSectionCompleted = (json["StudentEthnicityInformation"]["StudentEthnicityInformationSectionCompleted"].stringValue)
                self.studentFamilyInformationSectionCompleted = (json["StudentFamilyInformation"]["StudentFamilyInformationSectionCompleted"].stringValue)
                self.studentGPASectionCompleted = (json["StudentGPAInformation"]["StudentGPAInformationSectionCompleted"].stringValue)
                self.studentSATTakenSectionCompleted = (json["StudentSATInformation"]["StudentMathSATScore"].stringValue)
                self.studentACTTakenSectionCompleted = (json["StudentACTInformation"]["StudentMathACTScore"].stringValue)
            }
        })
    }
    
    @IBAction func letsFindACollegeFromWelcomeScreen(_ sender: UIButton) {
        performSegue(withIdentifier: "welcomeScreenToFindACollege", sender: self)
    }
    
    @IBAction func returnToQuestionnaireFromWelcomeScreen(_ sender: UIButton) {
        if studentGeneralInformationSectionCompleted == "false" || studentGeneralInformationSectionCompleted == "" {
            performSegue(withIdentifier: "resumeQuestionnaireGeneralInformation", sender: self)
        } else if studentEthnicityInformationSectionCompleted == "false" || studentEthnicityInformationSectionCompleted == "" {
            performSegue(withIdentifier: "resumeQuestionnaireEthnicity", sender: self)
        } else if studentFamilyInformationSectionCompleted == "false" || studentFamilyInformationSectionCompleted == "" {
            performSegue(withIdentifier: "resumeQuestionnaireFamily", sender: self)
        } else if studentGPASectionCompleted == "false" || studentGPASectionCompleted == "" {
            performSegue(withIdentifier: "resumeQuestionnaireGPA", sender: self)
        } else if studentSATTakenSectionCompleted == "" {
            performSegue(withIdentifier: "resumeQuestionnaireSATTaken", sender: self)
        } else if studentACTTakenSectionCompleted == "" {
            performSegue(withIdentifier: "resumeQuestionnaireACTTaken", sender: self)
        } else {
            performSegue(withIdentifier: "resumeQuestionnaireFinished", sender: self)
        }
    }
}
