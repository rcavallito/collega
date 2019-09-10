//
//  SATScoresQuestionnaireViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 6/27/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class SATScoresQuestionnaireViewController: UIViewController {

    @IBOutlet weak var satScoresInformationTextLabel: UILabel!
    
    //For the sliders
    @IBOutlet weak var sliderSATReadingWritingScore: UISlider!
    @IBOutlet weak var sliderSATReadingWritingScoreResult: UILabel!
    @IBOutlet weak var sliderSATMathScoreResult: UILabel!
    @IBOutlet weak var sliderSATMathScore: UISlider!
    @IBOutlet weak var sliderSATEssay1Score: UISlider!
    @IBOutlet weak var sliderSATEssay1ScoreResult: UILabel!
    @IBOutlet weak var sliderSATEssay2Score: UISlider!
    @IBOutlet weak var sliderSATEssay2ScoreResult: UILabel!
    @IBOutlet weak var sliderSATEssay3Score: UISlider!
    @IBOutlet weak var sliderSATEssay3ScoreResult: UILabel!
    
    let step: Float = 10

    var ref:DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderSATReadingWritingScoreResult.text = "Score"
        sliderSATMathScoreResult.text = "Score"
        sliderSATEssay1ScoreResult.text = "Score"
        sliderSATEssay2ScoreResult.text = "Score"
        sliderSATEssay3ScoreResult.text = "Score"
        
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.satScoresInformationTextLabel.text = "Now \(studentFirstName), how did you do?"
        }
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
    
    //Slider for Essay 1 scores
    @IBAction func essay1SliderChanged(_ sender: UISlider) {
        let roundedEssay1Value = round(sliderSATEssay1Score.value)
        sliderSATEssay1Score.value = roundedEssay1Value
        sliderSATEssay1ScoreResult.text = String(Int(sliderSATEssay1Score.value))
    }
    
    //Slider for Essay 2 scores
    @IBAction func essay2SliderChanged(_ sender: UISlider) {
        let roundedEssay2Value = round(sliderSATEssay2Score.value)
        sliderSATEssay2Score.value = roundedEssay2Value
        sliderSATEssay2ScoreResult.text = String(Int(sliderSATEssay2Score.value))
    }

    //Slider for Essay 3 scores
    @IBAction func essay3SliderChanged(_ sender: UISlider) {
        let roundedEssay3Value = round(sliderSATEssay3Score.value)
        sliderSATEssay3Score.value = roundedEssay3Value
        sliderSATEssay3ScoreResult.text = String(Int(sliderSATEssay3Score.value))
    }

    //This is for the "Why are you asking ... "
    @IBAction func whyAskingFromSATScoresQuestionnaire(_ sender: UIButton) {
        performSegue(withIdentifier: "whyAskingFromSATScoresQuestionnaire", sender: self)
    }
    
    //Sends SAT score information to Firebase
    @IBAction func submitSATScoresPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }

        let studentSATScores = ["StudentReadingWritingSATScore" : sliderSATReadingWritingScore.value, "StudentMathSATScore" : sliderSATMathScore.value, "StudentEssay1SATScore" : sliderSATEssay1Score.value, "StudentEssay2SATScore" : sliderSATEssay2Score.value, "StudentEssay3SATScore" : sliderSATEssay3Score.value] as [String : Any]
        ref?.child("Students").child(curUserId).child("StudentSATInformation").updateChildValues(studentSATScores)
        
        performSegue(withIdentifier: "goToACTQuestionnaire", sender: self)
    }
    
}
