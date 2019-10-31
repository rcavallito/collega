//
//  ConfirmPersonalInformationViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 8/7/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class ConfirmPersonalInformationViewController: UIViewController {
    
    var ref:DatabaseReference?
    
    @IBOutlet weak var studentUnweightedGPAToConfirm: UIButton!
    @IBOutlet weak var studentWeightedGPAToConfirm: UIButton!
    @IBOutlet weak var studentSATScoreToConfirm: UIButton!
    @IBOutlet weak var studentACTScoreToConfirm: UIButton!
    @IBOutlet weak var studentFamilyIncomeToConfirm: UIButton!
    @IBOutlet weak var studentSexToConfirm: UIButton!
    @IBOutlet weak var studentParentsEducationLevelToConfirm: UIButton!
    @IBOutlet weak var studentEthnicityToConfirm: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                
                //Unweighted GPA Score fetch from Firebase
                if (json["StudentGPAInformation"]["StudentUnweightedGPA"].intValue) > 0
                {
                    let studentUnweightedGPA = (json["StudentGPAInformation"]["StudentUnweightedGPA"].stringValue)
                    self.studentUnweightedGPAToConfirm.setTitle(studentUnweightedGPA, for: .normal)
                } else {
                    self.studentUnweightedGPAToConfirm.setTitle("Not provided", for: .normal)
                }
                
                //Weighted GPA Score fetch from Firebase
                if (json["StudentGPAInformation"]["StudentWeightedGPA"].intValue) > 0
                {
                    let studentWeightedGPA = (json["StudentGPAInformation"]["StudentWeightedGPA"].stringValue)
                    self.studentWeightedGPAToConfirm.setTitle(studentWeightedGPA, for: .normal)
                } else {
                    self.studentWeightedGPAToConfirm.setTitle("Not provided", for: .normal)
                }
                
                //SAT Score fetch from Firebase
                if (json["StudentSATInformation"]["TakenSAT"].stringValue) == "true"
                {
                let studentSATMathScore = (json["StudentSATInformation"]["StudentMathSATScore"].intValue)
                let studentSATEnglishScore = (json["StudentSATInformation"]["StudentReadingWritingSATScore"].intValue)
                let studentSATScore = String(studentSATMathScore + studentSATEnglishScore)
                self.studentSATScoreToConfirm.setTitle(studentSATScore, for: .normal)
                } else {
                self.studentSATScoreToConfirm.setTitle("Not taken", for: .normal)
                }
                
                
                //ACT Score fetch from Firebase
                if (json["StudentACTInformation"]["TakenACT"].stringValue) == "true"
                {
                    let studentACTMathScore = (json["StudentACTInformation"]["StudentMathACTScore"].intValue)
                    let studentACTEnglishScore = (json["StudentACTInformation"]["StudentEnglishACTScore"].intValue)
                    let studentACTScienceScore = (json["StudentACTInformation"]["StudentScienceACTScore"].intValue)
                    let studentACTReadingScore = (json["StudentACTInformation"]["StudentReadingACTScore"].intValue)
                    
                    let studentACTScore = String((studentACTMathScore + studentACTEnglishScore + studentACTScienceScore + studentACTReadingScore)/4)
                    self.studentACTScoreToConfirm.setTitle(studentACTScore, for: .normal)
                } else {
                    let studentACTScore = "Not taken"
                    self.studentACTScoreToConfirm.setTitle(studentACTScore, for: .normal)
                }
                
                //Family Income fetch from Firebase
                if (json["StudentFamilyInformation"]["HouseholdIncome"].stringValue) != "" {
            self.studentFamilyIncomeToConfirm.setTitle((json["StudentFamilyInformation"]["HouseholdIncome"].stringValue), for: .normal)
                } else {
                self.studentFamilyIncomeToConfirm.setTitle("Not provided", for: .normal)
                }

                //Student Sex fetch from Firebase
                if (json["StudentSex"].stringValue) != "" {
                self.studentSexToConfirm.setTitle((json["StudentSex"].stringValue), for: .normal)
                } else {
                self.studentSexToConfirm.setTitle("Not provided", for: .normal)
                }
                
                //Student Parent's Education Level fetch from Firebase
                if (json["StudentFamilyInformation"]["ParentsEducationLevel"].stringValue) != "" {
                let studentParentsEducationLevel = (json["StudentFamilyInformation"]["ParentsEducationLevel"].stringValue)
                self.studentParentsEducationLevelToConfirm.setTitle(String(studentParentsEducationLevel), for: .normal)
                } else {
                self.studentParentsEducationLevelToConfirm.setTitle("Not provided", for: .normal)
                }
                
                //Student Ethnicity fetch from Firebase
                if (json["StudentEthnicityInformation"]["AmericanIndianAlaskaNative"]) == "true" {
                    self.studentEthnicityToConfirm.setTitle(String("American Indian or Alaska Native"), for: .normal)
                } else if (json["StudentEthnicityInformation"]["Asian"]) == "true"{
                    self.studentEthnicityToConfirm.setTitle(String("Asian"), for: .normal)
                } else if (json["StudentEthnicityInformation"]["BlackAfricanAmerican"]) == "true" {
                    self.studentEthnicityToConfirm.setTitle(String("Black or African American"), for: .normal)
                } else if (json["StudentEthnicityInformation"]["HispanicLatinoSpanish"]) == "true" {
                    self.studentEthnicityToConfirm.setTitle(String("Hispanic Latino or Spanish"), for: .normal)
                } else if (json["StudentEthnicityInformation"]["MiddleEasternNorthAfrican"]) == "true" {
                    self.studentEthnicityToConfirm.setTitle(String("Middle Eastern or North African"), for: .normal)
                } else if (json["StudentEthnicityInformation"]["NativeHawaiianOtherPacific"]) == "true" {
                    self.studentEthnicityToConfirm.setTitle(String("Native Hawaiian or Other Pacific"), for: .normal)
                } else if (json["StudentEthnicityInformation"]["White"]) == "true" {
                    self.studentEthnicityToConfirm.setTitle(String("White"), for: .normal)
                } else if (json["StudentEthnicityInformation"]["Other"]) == "true" {
                    self.studentEthnicityToConfirm.setTitle(String("Other"), for: .normal)
                } else {
                    self.studentEthnicityToConfirm.setTitle(String("Not provided"), for: .normal)
                }
            
        
            }
            
        })
        
    }
    
    @IBAction func looksGoodButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCollegesSelectedFromConfirmPersonalInformation", sender: self)
    }
    
}

