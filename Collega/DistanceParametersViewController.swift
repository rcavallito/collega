//
//  DistanceParametersViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 8/5/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class DistanceParametersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref:DatabaseReference?
    var remainInState : String = "false"
    var preferredRegion : String = "none"
    
    @IBOutlet weak var remainInStateLabel: UILabel!
    @IBOutlet weak var remainWithinZipCodeLabel: UILabel!
    @IBOutlet weak var distanceFromHomeZipCodeTextField: UITextField!
    
    let collegeRegionSelectionArray = ["-Select One-", "New England", "Mid-atlantic", "Great Lakes", "Plains", "Rocky Mountains", "Southeast", "Southwest", "West"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                let studentHomeState = (json["StudentHomeState"].stringValue)
                
                let studentHomeZipCode = (json["StudentHomeZipCode"].stringValue)
                
                self.remainInStateLabel.text = "I would like to remain in \(studentHomeState):"
                
                self.remainWithinZipCodeLabel.text = "of \(studentHomeZipCode)"
            }
            })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return collegeRegionSelectionArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return collegeRegionSelectionArray[row]
    }
    
    // This is for when we take the data selected and do something with it:
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            preferredRegion = collegeRegionSelectionArray[row]
            print(preferredRegion)
    }
    
    @IBAction func remainInStateSwitch(_ sender: UISwitch) {
            if (sender.isOn == true) {
                remainInState = "true"
            }
            else {
                remainInState = "false"
            }
    }
    
    @IBAction func submitDistanceParametersToSearchSubmitted(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        let studentPreferredDistanceParameters = ["RemainInState" : remainInState, "DistanceFromHomeZipCode" : distanceFromHomeZipCodeTextField.text ?? "none", "PreferredRegion" : preferredRegion] as [String : Any]
        ref?.child("Students").child(curUserId).child("SearchParameters").child("DistanceSearchParameters").setValue(studentPreferredDistanceParameters)
        
        performSegue(withIdentifier: "goToGuidedCollegeSearchFromDistanceParameters", sender: self)
    }
    
    @IBAction func submitDistanceParametersToCostSubmitted(_ sender: UIButton) {
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        let studentPreferredDistanceParameters = ["RemainInState" : remainInState, "DistanceFromHomeZipCode" : distanceFromHomeZipCodeTextField.text ?? "none", "PreferredRegion" : preferredRegion] as [String : Any]
        
        ref?.child("Students").child(curUserId).child("SearchParameters").child("DistanceSearchParameters").setValue(studentPreferredDistanceParameters)
        
        performSegue(withIdentifier: "goToCostConcernsFromDistanceParameters", sender: self)
    }
    
    
}
