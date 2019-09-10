//
//  GPAQuestionnaireViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 6/27/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class GPAQuestionnaireViewController: UIViewController {

    @IBOutlet weak var gpaInformationTextLabel: UILabel!

    @IBOutlet weak var sliderUnweightedGPA: UISlider!
    @IBOutlet weak var sliderUnweightedGPAResult: UILabel!
    @IBOutlet weak var sliderWeightedGPA: UISlider!
    @IBOutlet weak var sliderWeightedGPAResult: UILabel!
    
    var ref:DatabaseReference?
    let step: Float = 0.01
    var studentUnweightedGPA : Float = 0.00
    var studentWeightedGPA : Float = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.gpaInformationTextLabel.text = "Terrific \(studentFirstName), now we need to know a little more about your academic situation:"
        }
    }
    
    @IBAction func unweightedGPASliderValueChanged(_ sender: UISlider) {
        let roundedUnweightedGPA = round(sliderUnweightedGPA.value / step) * step
        sliderUnweightedGPA.value = roundedUnweightedGPA
        sliderUnweightedGPAResult.text = String(format: "%.2f", sliderUnweightedGPA.value)
    }
    
    @IBAction func weightedGPASliderValueChanged(_ sender: UISlider) {
        let roundedWeightedGPA = round(sliderWeightedGPA.value / step) * step
        sliderWeightedGPA.value = roundedWeightedGPA
        sliderWeightedGPAResult.text = String(format: "%.2f", sliderWeightedGPA.value)
    }

    //Send data to Firebase
    @IBAction func submitGPAInformationPressed(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }

        let studentGPAInformation = ["StudentUnweightedGPA" : String(format: "%.2f", sliderUnweightedGPA.value), "StudentWeightedGPA" : String(format: "%.2f", sliderWeightedGPA.value)] as [String : Any]

        ref?.child("Students").child(curUserId).child("StudentGPAInformation").setValue(studentGPAInformation)

        performSegue(withIdentifier: "goToSATQuestionnaire", sender: self)
    }
}
