//
//  UpdateSATScoresViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 8/7/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class UpdateSATScoresViewController: UIViewController {
    
    //For the sliders
    
    @IBOutlet weak var updateSATReadingWritingScoreSlider: UISlider!
    @IBOutlet weak var updateSATReadingWritingScoreResult: UILabel!
    @IBOutlet weak var updateSATMathScoreSlider: UISlider!
    @IBOutlet weak var updateSATMathScoreResult: UILabel!

    let step: Float = 10
    var studentSATMathScore : Int = 0
    var studentSATEnglishScore : Int = 0
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Calling the student's information from Firebase
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                self.studentSATMathScore = (json["StudentSATInformation"]["StudentMathSATScore"].intValue)
                self.studentSATEnglishScore = (json["StudentSATInformation"]["StudentReadingWritingSATScore"].intValue)
            
                self.updateSATReadingWritingScoreResult.text = String(self.studentSATEnglishScore)
                self.updateSATMathScoreResult.text = String(self.studentSATMathScore)
                
                self.updateSATReadingWritingScoreSlider.value = Float(self.studentSATEnglishScore)
                self.updateSATMathScoreSlider.value = Float(self.studentSATMathScore)
            }
        })
    }
    
    //Slider for Reading/Writing scores
    @IBAction func updatedSATReadingWritingSliderValueChanged(_ sender: UISlider) {
        let roundedSATReadingWritingValue = round(updateSATReadingWritingScoreSlider.value / step) * step
        updateSATReadingWritingScoreSlider.value = roundedSATReadingWritingValue
        updateSATReadingWritingScoreResult.text = String(Int(updateSATReadingWritingScoreSlider.value))
    }
    
    //Slider for Math scores
    
    @IBAction func updatedSATMathSliderValueChanged(_ sender: UISlider) {
        let roundedSATMathValue = round(updateSATMathScoreSlider.value / step) * step
        updateSATMathScoreSlider.value = roundedSATMathValue
        updateSATMathScoreResult.text = String(Int(updateSATMathScoreSlider.value))
    }


    //Sends SAT score information to Firebase
    
    @IBAction func submitUpdateSATScoresPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }

        let studentSATScores = ["StudentReadingWritingSATScore" : updateSATReadingWritingScoreSlider.value, "StudentMathSATScore" : updateSATMathScoreSlider.value, "TakenSAT" : "true"] as [String : Any]
        ref?.child("Students").child(curUserId).child("StudentSATInformation").updateChildValues(studentSATScores)

        navigationController?.popViewController(animated: true)
        
        //DELETE AFTER TESTING - This is only necessary when testing in situations where App is started before Nav Controller
        self.dismiss(animated: true, completion: nil)
    }
}
