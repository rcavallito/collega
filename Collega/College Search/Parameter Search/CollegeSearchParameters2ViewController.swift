//  CollegeSearchParameters2ViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 10/28/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class CollegeSearchParameters2ViewController: UIViewController {
    
    @IBOutlet weak var distanceSearchParametersTextLabel: UILabel!
    
    @IBOutlet weak var studentSelectedCollegeSizeSlider: UISlider!
    @IBOutlet weak var studentSelectedCollegeSettingSlider: UISlider!
    
    @IBOutlet weak var remainInStateTextLabel: UILabel!
    @IBOutlet weak var zipCodeTextLabel: UILabel!
    @IBOutlet weak var studentSelectedDistanceFromHomeSlider: UISlider!
    
    
    //To round up slider to whole number
    let step: Float = 1.0
    
    //Dictionaries for converting slider Int into Strings of useful data
    let studentSelectedDistanceFromHomeDictionary = [1 : "Any", 2 : "50", 3 : "100", 4 : "250", 5 : "500", 6 : "1,000", 7 : "1,500"]
    let studentSelectedCollegeSizeDictionary = [0 : "Any", 1 : "Small", 2 : "Medium", 3 : "Large"]
    let studentSelectedCollegeSettingDictionary = [0 : "Any", 1 : "Urban", 2 : "Suburban", 3 : "Rural"]
    
    
    //Creating variable for Firebase calls
    var ref: DatabaseReference?
    
    var studentSelectedCollegeSize = "Any"
    var studentSelectedCollegeSetting = "Any"
    var remainInState : String = "False"
    var studentSelectedDistanceFromHome = "Any"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                let studentHomeState = (json["StudentHomeState"].stringValue)
                
                let studentHomeZipCode = (json["StudentHomeZipCode"].stringValue)
                
                self.remainInStateTextLabel.text = "Would you like to remain in \(studentHomeState)?"
                
                self.zipCodeTextLabel.text = "Within a certain distance of \(studentHomeZipCode)?"
            }
        })
        
        //Slider settings
        studentSelectedDistanceFromHomeSlider.minimumValue = 1
        studentSelectedDistanceFromHomeSlider.maximumValue = 7
        studentSelectedDistanceFromHomeSlider.value = 1
        
        studentSelectedCollegeSizeSlider.minimumValue = 0
        studentSelectedCollegeSizeSlider.maximumValue = 3
        studentSelectedCollegeSizeSlider.value = 0
        
        studentSelectedCollegeSettingSlider.minimumValue = 0
        studentSelectedCollegeSettingSlider.maximumValue = 3
        studentSelectedCollegeSettingSlider.value = 0
        
        //Dynamic content allowing for personalization of First Name from User Defaults
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.distanceSearchParametersTextLabel.text = "Terrific \(studentFirstName), now let's go through and set some additional parameters for your college search. Again, if you're not sure, then just leave the setting at the initial, recommended setting:"
        }
    }
    
    @IBAction func studentSelectedCollegeSizeSliderChanged(_ sender: UISlider) {
        let roundedStudentSelectedCollegeSizeResult = round(studentSelectedCollegeSizeSlider.value / step) * step
        
            studentSelectedCollegeSizeSlider.value = roundedStudentSelectedCollegeSizeResult
    }
    
    @IBAction func studentSelectedCollegeSettingSliderChanged(_ sender: UISlider) {
        let roundedStudentSelectedCollegeSettingResult = round(studentSelectedCollegeSettingSlider.value / step) * step
        
            studentSelectedCollegeSettingSlider.value = roundedStudentSelectedCollegeSettingResult
    }
    
    @IBAction func remainInStateSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            remainInState = "True"
        } else {
            remainInState = "False"
        }
    }
    
    @IBAction func studentSelectedDistanceFromHomeSliderChanged(_ sender: UISlider) {
        let roundedStudentSelectedDistanceFromHomeResult = round(studentSelectedDistanceFromHomeSlider.value / step) * step
        
            studentSelectedDistanceFromHomeSlider.value = roundedStudentSelectedDistanceFromHomeResult
    }
    
    
    @IBAction func submitCollegeDistanceSearchParametersSubmitted(_ sender: UIButton) {
        
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        let studentAdditionalSearchParametersPreferences = ["StudentSelectedCollegeSize" : studentSelectedCollegeSizeDictionary[Int(studentSelectedCollegeSizeSlider.value)]!, "StudentSelectedCollegeSetting" : studentSelectedCollegeSettingDictionary[Int(studentSelectedCollegeSettingSlider.value)]!, "StudentSelectedRemainInState" : remainInState, "StudentSelectedDistanceFromZipCode" : studentSelectedDistanceFromHomeDictionary[Int(studentSelectedDistanceFromHomeSlider.value)]!] as [String : Any]
        ref?.child("Students").child(curUserId).child("StudentSearchParametersPreferences").updateChildValues(studentAdditionalSearchParametersPreferences)
         
         performSegue(withIdentifier: "goToMiscSearchParametersViewController", sender: self)
                
        }
}
    
