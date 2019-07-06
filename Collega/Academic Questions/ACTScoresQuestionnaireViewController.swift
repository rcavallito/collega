//
//  ACTScoresQuestionnaireViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 7/5/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class ACTScoresQuestionnaireViewController: UIViewController {

    @IBOutlet weak var actScoresInformationTextLabel: UILabel!
    
    //For the sliders
    @IBOutlet weak var sliderACTEnglishScore: UISlider!
    @IBOutlet weak var sliderACTEnglishScoreResult: UILabel!
    @IBOutlet weak var sliderACTMathScore: UISlider!
    @IBOutlet weak var sliderACTMathScoreResult: UILabel!
    @IBOutlet weak var sliderACTReadingScore: UISlider!
    @IBOutlet weak var sliderACTReadingScoreResult: UILabel!
    @IBOutlet weak var sliderACTScienceScore: UISlider!
    @IBOutlet weak var sliderACTScienceScoreResult: UILabel!
    @IBOutlet weak var sliderACTEssayScore: UISlider!
    @IBOutlet weak var sliderACTEssayScoreResult: UILabel!
    
    let step: Float = 1
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderACTEnglishScoreResult.text = "Score"
        sliderACTMathScoreResult.text = "Score"
        sliderACTReadingScoreResult.text = "Score"
        sliderACTScienceScoreResult.text = "Score"
        sliderACTEssayScoreResult.text = "Score"
        
        //The opening paragraph which calls the Student's first name from Firebase
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                let studentFirstName = (json["StudentFirstName"].stringValue)
                
                self.actScoresInformationTextLabel.text = "Now \(studentFirstName), how did you do?"
            }
        })
    }
    
    //Slider for English scores
    @IBAction func actEnglishSliderChanged(_ sender: UISlider) {
        let roundedACTEnglishValue = round(sliderACTEnglishScore.value / step) * step
        sliderACTEnglishScore.value = roundedACTEnglishValue
        sliderACTEnglishScoreResult.text = String(Int(sliderACTEnglishScore.value))
    }
    
    //Slider for Math scores
    @IBAction func actMathSliderChanged(_ sender: UISlider) {
        let roundedACTMathValue = round(sliderACTMathScore.value / step) * step
        sliderACTMathScore.value = roundedACTMathValue
        sliderACTMathScoreResult.text = String(Int(sliderACTMathScore.value))
    }
    
    //Slider for Reading scores
    @IBAction func actReadingSliderChanged(_ sender: UISlider) {
        let roundedACTReadingValue = round(sliderACTReadingScore.value / step) * step
        sliderACTReadingScore.value = roundedACTReadingValue
        sliderACTReadingScoreResult.text = String(Int(sliderACTReadingScore.value))
    }
    
    //Slider for Science scores
    @IBAction func actScienceSliderChanged(_ sender: UISlider) {
        let roundedACTScienceValue = round(sliderACTScienceScore.value / step) * step
        sliderACTScienceScore.value = roundedACTScienceValue
        sliderACTScienceScoreResult.text = String(Int(sliderACTScienceScore.value))
    }
    
    //Slider for Essay scores
    @IBAction func actEssaySliderChanged(_ sender: UISlider) {
        let roundedACTEssayValue = round(sliderACTEssayScore.value / step) * step
        sliderACTEssayScore.value = roundedACTEssayValue
        sliderACTEssayScoreResult.text = String(Int(sliderACTEssayScore.value))
    }
    
    
    //Sends ACT score information to Firebase
    @IBAction func submitACTScoresPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        let studentACTScores = ["StudentEnglishACTScore" : sliderACTEnglishScore.value, "StudentMathACTScore" : sliderACTMathScore.value, "StudentReadingACTScore" : sliderACTReadingScore.value, "StudentScienceACTScore" : sliderACTScienceScore.value, "StudentEssayACTScore" : sliderACTEssayScore.value] as [String : Any]
        
        ref?.child("Students").child(curUserId).child("StudentACTInformation").updateChildValues(studentACTScores)
    }
    
}
