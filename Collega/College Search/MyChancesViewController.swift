//
//  MyChancesViewController.swift
//  Alamofire
//
//  Created by Robert Cavallito on 8/1/19.
//

import UIKit
import Firebase
import SwiftyJSON
import Alamofire

class MyChancesViewController: UIViewController {
    
    var collegeListInfo = JSON()
    let apiKey = "pzTiQAuLWx613F6yeC9Kk30q7Yn0g1tgpJdARPhM"
    let baseURL = "https://api.data.gov/ed/collegescorecard/v1/schools?"
    var finalURL = ""
    var selectedCollegeID = String()
    var studentFamilyIncomeCoded = Int()
    var ref:DatabaseReference?
    
    @IBOutlet weak var m_lblCollegeName: UILabel!
    @IBOutlet weak var m_lblCollegeCity: UILabel!
    @IBOutlet weak var m_lblCollegeState: UILabel!
    @IBOutlet weak var m_lblCollegeZipCode: UILabel!
    @IBOutlet weak var m_lblCollegeURL: UILabel!
    @IBOutlet weak var m_lblCollegeAverageSATScore: UILabel!
    @IBOutlet weak var m_lblStudentSATScore: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                let studentFamilyIncome = (json["StudentFamilyInformation"]["HouseholdIncome"].stringValue)
                let studentSATMathScore = (json["StudentSATInformation"]["StudentMathSATScore"].intValue)
                let studentSATReadingScore = (json["StudentSATInformation"]["StudentReadingWritingSATScore"].intValue)
                let studentSATScore = studentSATReadingScore + studentSATMathScore
                    
                print(studentFamilyIncome)
                print(studentSATMathScore)
                
                if studentFamilyIncome == "<$30,000" {
                    self.studentFamilyIncomeCoded = 1
                } else if studentFamilyIncome == "$30,001 - $48,000" {
                    self.studentFamilyIncomeCoded = 2
                } else if studentFamilyIncome == "$48,001 - $75,000" {
                    self.studentFamilyIncomeCoded = 3
                } else if studentFamilyIncome == "$75,000 - $110,000" {
                    self.studentFamilyIncomeCoded = 4
                } else {
                    self.studentFamilyIncomeCoded = 5
                }
                
                self.m_lblStudentSATScore.text = String(studentSATScore)
                

            }
            
        })
        
        getCollegeLists(idCode: selectedCollegeID)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }


    func getCollegeLists(idCode: String? = nil, additionalFields: [String: String]? = ["_fields": "school.name,id,school.city,school.state,school.zip,school.school_url,latest.admissions.sat_scores.average.overall,latest.admissions.act_scores.midpoint.cumulative,latest.admissions.sat_scores.25th_percentile.critical_reading,latest.admissions.sat_scores.75th_percentile.critical_reading,latest.admissions.sat_scores.25th_percentile.math,latest.admissions.sat_scores.75th_percentile.math"]) {
        
        var parameters = [
            "api_key": apiKey
        ]
        
        if let idCode = idCode, !idCode.isEmpty {
            parameters["id"] = "\(idCode)"
        }
        if let additionalFields = additionalFields {
            parameters.merge(additionalFields) { (_, current) in current }
        }
        
        let url = baseURL + buildParameterString(parameters: parameters)
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    self.collegeListInfo = json
                    self.processCollegeList()
                } else {
                    print("Error: \(String(describing: response.result.error))")
                }
        }
    }
    
    func buildParameterString(parameters: [String: String]) -> String {
        var arrParameters = [String]()
        for parameter in parameters {
            arrParameters.append("\(parameter.key)=\(parameter.value)")
        }
        let parameterString = arrParameters.joined(separator: "&")
        print(parameterString)
        return parameterString
    }
    
    
    //MARK: - JSON Parsing
    func processCollegeList() {
        
        print(">>>===== Start ========")
        print(collegeListInfo)
        print(">>>===== End ========")
        
        self.m_lblCollegeName.text = (collegeListInfo["results"][0]["school.name"].stringValue)
        self.m_lblCollegeCity.text = "\(collegeListInfo["results"][0]["school.city"].stringValue),"
        self.m_lblCollegeState.text = (collegeListInfo["results"][0]["school.state"].stringValue)
        self.m_lblCollegeZipCode.text = (collegeListInfo["results"][0]["school.zip"].stringValue)
        self.m_lblCollegeURL.text = (collegeListInfo["results"][0]["school.school_url"].stringValue)
    
        print(collegeListInfo["results"][0]["latest.admissions.sat_scores.25th_percentile.critical_reading"].stringValue)
        print(collegeListInfo["results"][0]["latest.admissions.sat_scores.75th_percentile.critical_reading"].stringValue)
        print(collegeListInfo["results"][0]["latest.admissions.sat_scores.25th_percentile.math"].stringValue)
        print(collegeListInfo["results"][0]["latest.admissions.sat_scores.75th_percentile.math"].stringValue)
        
        self.m_lblCollegeAverageSATScore.text = (collegeListInfo["results"][0]["latest.admissions.sat_scores.average.overall"].stringValue)
        
        //self.m_lblStudentSATScore.text = String(studentSATMathScore)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        
    }
    
    //DELETE AFTER TESTING!
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
        //DELETE AFTER TESTING! - This is only necessary when testing in situations where App is started before Nav Controller
        self.dismiss(animated: true, completion: nil)
   
    
    }

}
