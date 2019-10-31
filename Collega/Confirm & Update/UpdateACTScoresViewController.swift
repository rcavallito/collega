//
//  UpdateACTScoresViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 8/7/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class UpdateACTScoresViewController: UIViewController {
    
    //For the sliders
    @IBOutlet weak var updateACTMathScoreSlider: UISlider!
    @IBOutlet weak var updateACTMathScoreResult: UILabel!
    @IBOutlet weak var updateACTEnglishScoreSlider: UISlider!
    @IBOutlet weak var updateACTEnglishScoreResult: UILabel!
    @IBOutlet weak var updateACTReadingScoreSlider: UISlider!
    @IBOutlet weak var updateACTReadingScoreResult: UILabel!
    @IBOutlet weak var updateACTScienceScoreSlider: UISlider!
    @IBOutlet weak var updateACTScienceScoreResult: UILabel!
    
    let step: Float = 1
    var studentACTMathScore : Int = 0
    var studentACTEnglishScore : Int = 0
    var studentACTReadingScore : Int = 0
    var studentACTScienceScore : Int = 0
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calling the student's information from Firebase
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                
                self.studentACTMathScore = (json["StudentACTInformation"]["StudentMathACTScore"].intValue)
                self.studentACTEnglishScore = (json["StudentACTInformation"]["StudentEnglishACTScore"].intValue)
                self.studentACTReadingScore = (json["StudentACTInformation"]["StudentReadingACTScore"].intValue)
                self.studentACTScienceScore = (json["StudentACTInformation"]["StudentScienceACTScore"].intValue)
                
                self.updateACTMathScoreResult.text = String(self.studentACTMathScore)
                self.updateACTEnglishScoreResult.text = String(self.studentACTEnglishScore)
                self.updateACTReadingScoreResult.text = String(self.studentACTReadingScore)
                self.updateACTScienceScoreResult.text = String(self.studentACTScienceScore)
                
                self.updateACTMathScoreSlider.value = Float(self.studentACTMathScore)
                self.updateACTEnglishScoreSlider.value = Float(self.studentACTEnglishScore)
                self.updateACTReadingScoreSlider.value = Float(self.studentACTReadingScore)
                self.updateACTScienceScoreSlider.value = Float(self.studentACTScienceScore)
            }
        })
        
    }
    
    //Sliders
    @IBAction func updatedACTMathSliderValueChanged(_ sender: UISlider) {
        let roundedACTMathValue = round(updateACTMathScoreSlider.value / step) * step
        updateACTMathScoreSlider.value = roundedACTMathValue
        updateACTMathScoreResult.text = String(Int(updateACTMathScoreSlider.value))
    }
    
    @IBAction func updatedACTEnglishSliderValueChanged(_ sender: UISlider) {
        let roundedACTEnglishValue = round(updateACTEnglishScoreSlider.value / step) * step
        updateACTEnglishScoreSlider.value = roundedACTEnglishValue
        updateACTEnglishScoreResult.text = String(Int(updateACTEnglishScoreSlider.value))
    }
    
    @IBAction func updatedACTReadingSliderValueChanged(_ sender: UISlider) {
        let roundedACTReadingValue = round(updateACTReadingScoreSlider.value / step) * step
        updateACTReadingScoreSlider.value = roundedACTReadingValue
        updateACTReadingScoreResult.text = String(Int(updateACTReadingScoreSlider.value))
    }
    
    @IBAction func updatedACTScienceSliderValueChanged(_ sender: UISlider) {
        let roundedACTScienceValue = round(updateACTScienceScoreSlider.value / step) * step
        updateACTScienceScoreSlider.value = roundedACTScienceValue
        updateACTScienceScoreResult.text = String(Int(updateACTScienceScoreSlider.value))
    }
    
    //Sends ACT score information to Firebase
    @IBAction func submitUpdateACTScoresPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }

        let studentACTScores = ["StudentMathACTScore" : updateACTMathScoreSlider.value, "StudentEnglishACTScore" : updateACTEnglishScoreSlider.value, "StudentReadingACTScore" : updateACTReadingScoreSlider.value, "StudentScienceACTScore" : updateACTScienceScoreSlider.value, "TakenACT" : "true"] as [String : Any]
        ref?.child("Students").child(curUserId).child("StudentACTInformation").updateChildValues(studentACTScores)

        navigationController?.popViewController(animated: true)
        
        //DELETE AFTER TESTING - This is only necessary when testing in situations where App is started before Nav Controller
        self.dismiss(animated: true, completion: nil)
    }
}
