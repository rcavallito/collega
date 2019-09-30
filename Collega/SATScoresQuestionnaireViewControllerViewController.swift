//
//  SATScoresQuestionnaireViewControllerViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 6/27/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class SATScoresQuestionnaireViewControllerViewController: UIViewController {

    @IBOutlet weak var satScoresInformationTextLabel: UILabel!
    
    //For the sliders
    @IBOutlet weak var sliderSATReadingWritingScore: UISlider!
    @IBOutlet weak var sliderSATReadingWritingScoreResult: UILabel!
    @IBOutlet weak var sliderSATMathScoreResult: UILabel!
    @IBOutlet weak var sliderSATMathScore: UISlider!
    
    
    let step: Float = 10
    
    var isPSATOrSATScores : String = ""
    var ref:DatabaseReference?

    
    //Are the scores PSAT or SAT scores?
    @IBAction func isPSATOrSATScore(_ sender: UISwitch) {
        if (sender.isOn == true) {
            isPSATOrSATScores = "SAT"
        }
        else {
            isPSATOrSATScores = "PSAT"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderSATReadingWritingScoreResult.text = "Score"
        sliderSATMathScoreResult.text = "Score"
        
        //The opening paragraph which calls the Student's first name from Firebase
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                let studentFirstName = (json["StudentFirstName"].stringValue)
                
                self.satScoresInformationTextLabel.text = "Now \(studentFirstName), how did you do on the SAT? (If you've only taken the PSAT that's fine, you can use those scores. If you don't plan on taking the SAT, just enter N/A):"
            }
        })
    }
    
    //Slider for Reading/Writing scores
    @IBAction func satReadingWritingSliderChanged(_ sender: UISlider) {
        let roundedSATReadingWritingValue = round(sliderSATReadingWritingScore.value / step) * step
        sliderSATReadingWritingScore.value = roundedSATReadingWritingValue
        sliderSATReadingWritingScoreResult.text = String(Int(sliderSATReadingWritingScore.value))
    }
    
    //Slider for Math scores
    @IBAction func satMathSliderChanged(_ sender: UISlider) {
        let roundedSATMathValue = round(sliderSATMathScore.value / step) * step
        sliderSATMathScore.value = roundedSATMathValue
        sliderSATMathScoreResult.text = String(Int(sliderSATMathScore.value))
    }
    
    
    
    //Sends SAT score information to Firebase
    @IBAction func submitSATInformationPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        guard let curUserEmail = Auth.auth().currentUser?.email else { return }

        let studentSATInformation = ["StudentReadingWritingSATScore" : sliderSATReadingWritingScore.value, "StudentMathSATScore" : sliderSATMathScore.value, "StudentEssay1SATScore" : studentEssay1SATScoreTextField.text!, "StudentEssay2SATScore" : studentEssay2SATScoreTextField.text!, "StudentEssay3SATScore" : studentEssay3SATScoreTextField.text!, "IsSATOrPSATScore" : isPSATOrSATScores] as [String : Any]
        
        ref?.child("Students").child(curUserId).child("StudentSATInformation").setValue(studentSATInformation)
    }
    
}
