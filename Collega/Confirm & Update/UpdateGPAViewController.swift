//
//  UpdateGPAViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 9/8/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class UpdateGPAViewController: UIViewController {
    
    @IBOutlet weak var updateUnweightedGPASlider: UISlider!
    @IBOutlet weak var updateUnweightedGPAResult: UILabel!
    @IBOutlet weak var updateWeightedGPASlider: UISlider!
    @IBOutlet weak var updateWeightedGPAResult: UILabel!

    let step: Float = 0.01
    var studentUnweightedGPA : Float = 0.00
    var studentWeightedGPA : Float = 0.00
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calling the student's information from Firebase
        ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                
                self.studentUnweightedGPA = (json["StudentGPAInformation"]["StudentUnweightedGPA"].floatValue)
                self.studentWeightedGPA = (json["StudentGPAInformation"]["StudentWeightedGPA"].floatValue)

                self.updateUnweightedGPAResult.text = String(format: "%.2f", self.studentUnweightedGPA)
                self.updateWeightedGPAResult.text = String(format: "%.2f", self.studentWeightedGPA)
                
                self.updateUnweightedGPASlider.value = Float(self.studentUnweightedGPA)
                self.updateWeightedGPASlider.value = Float(self.studentWeightedGPA)
            }
        })
    }
    
    @IBAction func updatedUnweightedGPASliderValueChanged(_ sender: Any) {
        let roundedUnweightedGPA = round(updateUnweightedGPASlider.value / step) * step
        updateUnweightedGPASlider.value = roundedUnweightedGPA
        updateUnweightedGPAResult.text = String(format: "%.2f", updateUnweightedGPASlider.value)
    }
    
    
    @IBAction func updatedWeightedGPASliderValueChanged(_ sender: Any) {
        let roundedWeightedGPA = round(updateWeightedGPASlider.value / step) * step
        updateWeightedGPASlider.value = roundedWeightedGPA
        updateWeightedGPAResult.text = String(format: "%.2f", updateWeightedGPASlider.value)
    }
    
    @IBAction func submitUpdateGPAPressed(_ sender: UIButton) {
    
    guard let curUserId = Auth.auth().currentUser?.uid else { return }
    
    let studentUpdateGPA = ["StudentUnweightedGPA" : String(format: "%.2f", updateUnweightedGPASlider.value), "StudentWeightedGPA" : String(format: "%.2f", updateWeightedGPASlider.value)] as [String : Any]
    ref?.child("Students").child(curUserId).child("StudentGPAInformation").updateChildValues(studentUpdateGPA)
    
    navigationController?.popViewController(animated: true)
    
    //DELETE AFTER TESTING - This is only necessary when testing in situations where App is started before Nav Controller
    self.dismiss(animated: true, completion: nil)
    }
    
}



