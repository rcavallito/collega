//
//  QuestionnaireFinishedViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 7/8/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class QuestionnaireFinishedViewController: UIViewController {

    @IBOutlet weak var finishedScreenTextLabel: UITextView!
    
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
        
        if studentGraduationYear != "" || studentSex != "" || studentEthnicity != "" || studentFamilyInformation != "" || studentGPA != "" || studentSAT != "" || studentACT != "" {
            if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
                finishedScreenTextLabel.text = "Terrific \(studentFirstName), you're done with the questionnaire. Now, let's move on to the next step – searching for a college!"
            } else {
                if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
                    finishedScreenTextLabel.text = "Okay \(studentFirstName), it looks like you skipped an item or two, but you can go back at any time by clicking on Finish Questionnaire after you log in. You will also have other opportunities to update your information as you go through the college search process. For now, let's move on to the next steps!"
                    }
            }
        }
    }
    
    @IBAction func nextFromFinishedQuestionnaireScreen(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFindACollegeFromQuestionnaire", sender: self)
    }
}
