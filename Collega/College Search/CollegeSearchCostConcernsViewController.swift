//
//  CollegeSearchCostConcernsViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 7/29/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import Alamofire

class CollegeSearchCostConcernsViewController: UIViewController, UITextFieldDelegate {
    
    var collegeListInfo = JSON()
    let apiKey = "pzTiQAuLWx613F6yeC9Kk30q7Yn0g1tgpJdARPhM"
    let baseURL = "https://api.data.gov/ed/collegescorecard/v1/schools?"
    var finalURL = ""
    var collegeID = ""
    var studentFamilyIncome = ""
    var studentFamilyIncomeRevised = 1
    var netPricePublicForStudent = 0
    var netPricePrivateForStudent = 0
    
    @IBOutlet weak var lblPublicCollegeNameForNetCost: UILabel!
    @IBOutlet weak var lblPublicCollegeListPrice: UILabel!
    @IBOutlet weak var lblPublicCollegeNetPrice: UILabel!
    @IBOutlet weak var lblPrivateCollegeNameForNetCost: UILabel!
    @IBOutlet weak var lblPrivateCollegeListPrice: UILabel!
    @IBOutlet weak var lblPrivateCollegeNetPrice: UILabel!
    
    var ref:DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                let studentFamilyIncome = (json["StudentFamilyInformation"]["HouseholdIncome"].stringValue)
                
                if studentFamilyIncome == "<$30,000" {
                    self.studentFamilyIncomeRevised = 1
                } else if studentFamilyIncome == "$30,001 - $48,000" {
                    self.studentFamilyIncomeRevised = 2
                } else if studentFamilyIncome == "$48,001 - $75,000" {
                    self.studentFamilyIncomeRevised = 3
                } else if studentFamilyIncome == "$75,000 - $110,000" {
                    self.studentFamilyIncomeRevised = 4
                } else {
                    self.studentFamilyIncomeRevised = 5
                }
                
                print(studentFamilyIncome)
                print(self.studentFamilyIncomeRevised)
            }
            
        })
        
        getCollegeLists(idCode: "227757,228778")
       
    }
    
    func getCollegeLists(idCode: String? = nil, additionalFields: [String: String]? = ["_fields": "school.name,latest.cost.net_price.public.by_income_level.0-30000,latest.cost.net_price.public.by_income_level.30001-48000,latest.cost.net_price.public.by_income_level.48001-75000,latest.cost.net_price.public.by_income_level.75001-110000,latest.cost.net_price.public.by_income_level.110001-plus,latest.cost.net_price.private.by_income_level.0-30000,latest.cost.net_price.private.by_income_level.30001-48000,latest.cost.net_price.private.by_income_level.48001-75000,latest.cost.net_price.private.by_income_level.75001-110000,latest.cost.net_price.private.by_income_level.110001-plus"]) {
        
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
        
        if studentFamilyIncomeRevised == 1 {
            netPricePublicForStudent = Int(collegeListInfo["results"][0]["latest.cost.net_price.public.by_income_level.0-30000"].intValue)
        } else if studentFamilyIncomeRevised == 2 {
            netPricePublicForStudent = Int(collegeListInfo["results"][0]["latest.cost.net_price.public.by_income_level.30001-48000"].intValue)
        } else if studentFamilyIncomeRevised == 3 {
            netPricePublicForStudent = Int(collegeListInfo["results"][0]["latest.cost.net_price.public.by_income_level.48001-75000"].intValue)
        } else if studentFamilyIncomeRevised == 4 {
            netPricePublicForStudent = Int(collegeListInfo["results"][0]["latest.cost.net_price.public.by_income_level.75001-110000"].intValue)
        } else if studentFamilyIncomeRevised == 5 {
            netPricePublicForStudent = Int(collegeListInfo["results"][0]["latest.cost.net_price.public.by_income_level.110001-plus"].intValue)
        }
        
        
        if studentFamilyIncomeRevised == 1 {
            netPricePrivateForStudent = Int(collegeListInfo["results"][1]["latest.cost.net_price.private.by_income_level.0-30000"].intValue)
        } else if studentFamilyIncomeRevised == 2 {
            netPricePrivateForStudent = Int(collegeListInfo["results"][1]["latest.cost.net_price.private.by_income_level.30001-48000"].intValue)
        } else if studentFamilyIncomeRevised == 3 {
            netPricePrivateForStudent = Int(collegeListInfo["results"][1]["latest.cost.net_price.private.by_income_level.48001-75000"].intValue)
        } else if studentFamilyIncomeRevised == 4 {
            netPricePrivateForStudent = Int(collegeListInfo["results"][1]["latest.cost.net_price.private.by_income_level.75001-110000"].intValue)
        } else if studentFamilyIncomeRevised == 5 {
            netPricePrivateForStudent = Int(collegeListInfo["results"][1]["latest.cost.net_price.private.by_income_level.110001-plus"].intValue)
        }
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNetPricePublicForStudent = numberFormatter.string(from: NSNumber(value:netPricePublicForStudent))
        
        let formattedNetPricePrivateForStudent = numberFormatter.string(from: NSNumber(value:netPricePrivateForStudent))
        
        lblPublicCollegeNameForNetCost.text = collegeListInfo["results"][0]["school.name"].stringValue
        lblPublicCollegeNetPrice.text = "$\(formattedNetPricePublicForStudent!)"
        lblPublicCollegeListPrice.text = "$28,756"
        
        lblPrivateCollegeNameForNetCost.text = collegeListInfo["results"][1]["school.name"].stringValue
        lblPrivateCollegeNetPrice.text = "$\(formattedNetPricePrivateForStudent!)"
        lblPrivateCollegeListPrice.text = "$67,102"
        
    }

}
