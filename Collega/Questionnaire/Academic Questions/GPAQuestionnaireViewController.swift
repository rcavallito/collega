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
    
    //Creating variable for Firebase calls
    var ref:DatabaseReference?
    
    //Creating variables for the slider number to increase in increments of .01
    let step: Float = 0.01

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase
        ref = Database.database().reference()
        
        //Dynamic content allowing for personalization of First Name from User Defaults
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.gpaInformationTextLabel.text = "Terrific \(studentFirstName), now we need some academic information:"
        }
    }
    
    //Functions for each of the sliders, rounding them to the nearest hundreth (x.xx)
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
    
    //This is for the "Why are you asking ... "
    @IBAction func whyAskingFromGPAQuestionnaire(_ sender: UIButton) {
        performSegue(withIdentifier: "whyAskingFromGPAQuestionnaire", sender: self)
    }
    
    

    //Send data to Firebase
    @IBAction func submitGPAInformationPressed(_ sender: UIButton) {
        
        guard let curUserId = Auth.auth().currentUser?.uid else { return }

        //Checking to ensure that all the fields have been updated in order to satisfy "StudentGPAInformationSectionCompleted" as True || False
        if sliderWeightedGPA.value > 0 && sliderUnweightedGPA.value > 0 {
               
                let studentGPAInformation = ["StudentUnweightedGPA" : String(format: "%.2f", sliderUnweightedGPA.value), "StudentWeightedGPA" : String(format: "%.2f", sliderWeightedGPA.value), "StudentGPAInformationSectionCompleted" : "true"] as [String : Any]
            ref?.child("Students").child(curUserId).child("StudentGPAInformation").setValue(studentGPAInformation)
                   
               } else {
                   
                let studentGPAInformation = ["StudentUnweightedGPA" : String(format: "%.2f", sliderUnweightedGPA.value), "StudentWeightedGPA" : String(format: "%.2f", sliderWeightedGPA.value), "StudentGPAInformationSectionCompleted" : "false"] as [String : Any]
                ref?.child("Students").child(curUserId).child("StudentGPAInformation").setValue(studentGPAInformation)
               }

        performSegue(withIdentifier: "goToSATQuestionnaire", sender: self)
        
    }
}
