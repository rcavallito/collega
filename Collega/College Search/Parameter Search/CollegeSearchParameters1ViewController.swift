//  CollegeSearchParameters1ViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 10/23/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class CollegeSearchParameters1ViewController: UIViewController {
    
    @IBOutlet weak var studentSelectedPublicOrPrivateSlider: UISlider!
    @IBOutlet weak var studentSelected2YearOr4YearSlider: UISlider!
    @IBOutlet weak var studentSelectedResidentialOrCommuterSlider: UISlider!
    @IBOutlet weak var studentSelectedFullTimeOrPartTimeSlider: UISlider!
    
    @IBOutlet weak var collegeSearchParametersTextLabel: UILabel!
    
    
    //Variables defining student's preferences
    var studentSelectedPublicOrPrivateResult = "Any"
    var studentSelected2YearOr4YearResult = "4-Year"
    var studentSelectedResidentialOrCommuter = "Residential"
    var studentSelectedFullTimeOrPartTime = "Full-Time"
    
    //To round up slider to whole number
    let step: Float = 1.0
    
    //Dictionaries for converting slider Int into Strings of useful data
    let studentSelectedCollegeTypeDictionary = [0 : "Any", 1 : "Public", 2 : "Private"]
    let studentSelected2YearOr4YearDictionary = [0 : "Any", 1 : "4-Year", 2 : "2-Year"]
    let studentSelectedResidentialOrCommuterDictionary = [0 : "Any", 1 : "Residential", 2 : "Commuter"]
    let studentSelectedFullTimeOrPartTimeDictionary = [0 : "Any", 1 : ">40%", 2 : ">60%", 3 : ">90%"]
    
    let studentSelectedCollegeSizeDictionary = [0 : "Any", 1 : "Small", 2 : "Medium", 3 : "Large"]
    let studentSelectedCollegeSettingDictionary = [0 : "Any", 1 : "Urban", 2 : "Suburban", 3 : "Rural"]
    
    //Creating variable for Firebase calls
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase
        ref = Database.database().reference()
        
        //Dynamic content allowing for personalization of First Name from User Defaults
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.collegeSearchParametersTextLabel.text = "Okay \(studentFirstName), let's go through and set some parameters for your college search. If you're not sure, then just leave the setting at the initial, recommended setting:"
        }
        
        //Slider settings
        studentSelectedPublicOrPrivateSlider.minimumValue = 0
        studentSelectedPublicOrPrivateSlider.maximumValue = 2
        studentSelectedPublicOrPrivateSlider.value = 0
        
        studentSelected2YearOr4YearSlider.minimumValue = 0
        studentSelected2YearOr4YearSlider.maximumValue = 2
        studentSelected2YearOr4YearSlider.value = 1
        
        studentSelectedResidentialOrCommuterSlider.minimumValue = 0
        studentSelectedResidentialOrCommuterSlider.maximumValue = 2
        studentSelectedResidentialOrCommuterSlider.value = 1
        
        studentSelectedFullTimeOrPartTimeSlider.minimumValue = 0
        studentSelectedFullTimeOrPartTimeSlider.maximumValue = 3
        studentSelectedFullTimeOrPartTimeSlider.value = 3
    
    }
    
    @IBAction func studentSelectedPublicOrPrivateSliderChanged(_ sender: UISlider) {
        let roundedStudentSelectedPublicOrPrivateResult = round(studentSelectedPublicOrPrivateSlider.value / step) * step
    
        studentSelectedPublicOrPrivateSlider.value = roundedStudentSelectedPublicOrPrivateResult
    }
    
    @IBAction func studentSelected2YearOr4YearSliderChanged(_ sender: UISlider) {
        let roundedStudentSelected2YearOr4YearResult = round(studentSelected2YearOr4YearSlider.value / step) * step
        
        studentSelected2YearOr4YearSlider.value = roundedStudentSelected2YearOr4YearResult
    }
    
    @IBAction func studentSelectedResidentialOrCommuterSliderChanged(_ sender: UISlider) {
        
        let roundedStudentSelectedResidentialOrCommuterResult = round(studentSelectedResidentialOrCommuterSlider.value / step) * step
        
        studentSelectedResidentialOrCommuterSlider.value = roundedStudentSelectedResidentialOrCommuterResult
    }
    
    @IBAction func studentSelectedFullTimeOrPartTimeSliderChanged(_ sender: UISlider) {

        let roundedStudentSelectedFullTimeOrPartTimeResult = round(studentSelectedFullTimeOrPartTimeSlider.value / step) * step
        
        studentSelectedFullTimeOrPartTimeSlider.value = roundedStudentSelectedFullTimeOrPartTimeResult
    }
    
    
    @IBAction func submitCollegeSearchPreferences1Submitted(_ sender: UIButton) {
    
    guard let curUserId = Auth.auth().currentUser?.uid else { return }
       
        let studentSearchParametersPreferences = ["StudentSelectedPublicOrPrivate" : studentSelectedCollegeTypeDictionary[Int(studentSelectedPublicOrPrivateSlider.value)]!, "StudentSelected2YearOr4Year" : studentSelected2YearOr4YearDictionary[Int(studentSelected2YearOr4YearSlider.value)]!, "StudentSelectedResidentialOrCommuter" : studentSelectedResidentialOrCommuterDictionary[Int(studentSelectedResidentialOrCommuterSlider.value)]!, "StudentSelectedFullTimeOrPartTime" : studentSelectedFullTimeOrPartTimeDictionary[Int(studentSelectedFullTimeOrPartTimeSlider.value)]!] as [String : Any]
            
        ref?.child("Students").child(curUserId).child("StudentSearchParametersPreferences").setValue(studentSearchParametersPreferences)
        
        performSegue(withIdentifier: "goToCollegeSearchParameters2ViewController", sender: self)
               
           }
    
    }

