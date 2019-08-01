//
//  CollegeSearch1ViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 6/25/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CollegeSearch1ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var testingTableJSON: UITableView!
    @IBOutlet weak var collegeSearchTextField: UITextField!
    
    var collegeListInfo = JSON()
    var collegeList = [JSON]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return(collegeList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "collegeDisplayCell")
        cell.textLabel?.text = collegeList[indexPath.row]["school.name"].stringValue
        cell.detailTextLabel?.text = collegeList[indexPath.row]["school.state"].stringValue
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "showDetailsVCId", sender: indexPath)
    }
    
    //Sets color of background of table as well as text within tableview
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.white
        cell.textLabel?.textColor = UIColor(red:0.77, green:0.62, blue:0.09, alpha:1.0)
        cell.detailTextLabel?.textColor = UIColor(red:0.77, green:0.62, blue:0.09, alpha:1.0)
    }
    
    //Send data forward to next VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsVCId", let destVC = segue.destination as? CollegeDetailsViewController, let idxPath = sender as? IndexPath {
            destVC.selectedCollege = self.collegeList[idxPath.row]
        }
    }
    
    //Original part of the code where a function is run to get data and display a manually determined piece of it in the Name of College and Acceptance Rate labels.
    
    let apiKey = "pzTiQAuLWx613F6yeC9Kk30q7Yn0g1tgpJdARPhM"
    let baseURL = "https://api.data.gov/ed/collegescorecard/v1/schools?"
    var finalURL = ""
    var collegeSelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCollegeLists(name: "texas")
        
        testingTableJSON.delegate = self
        testingTableJSON.dataSource = self
        collegeSearchTextField.delegate = self
    }
    
    func getCollegeLists(schoolIsOperating: Int? = nil, zipCode: String? = nil, distanceInMile: Int? = nil, schoolState: String? = nil, perPage: Int? = nil, name: String? = nil, ownership: Int? = nil, additionalFields: [String: String]? = ["_fields": "school.name,school.city,school.state,school.zip,school.school_url,school.locale,school.men_only,school.women_only,latest.admissions.admission_rate.overall,latest.admissions.sat_scores.average.overall,latest.admissions.act_scores.midpoint.cumulative,school.ownership,latest.student.size,latest.student.grad_students,latest.student.demographics.men,latest.student.demographics.women,latest.student.part_time_share,latest.student.demographics.race_ethnicity.white,latest.student.demographics.race_ethnicity.black,latest.student.demographics.race_ethnicity.hispanic,latest.student.demographics.race_ethnicity.asian,latest.student.demographics.race_ethnicity.aian,latest.student.demographics.race_ethnicity.nhpi,latest.student.demographics.race_ethnicity.two_or_more,latest.student.demographics.race_ethnicity.non_resident_alien,latest.student.demographics.race_ethnicity.unknown,latest.student.retention_rate.four_year.full_time_pooled,latest.student.retention_rate.lt_four_year.full_time_pooled,school.degrees_awarded.predominant,latest.cost.net_price.public.by_income_level.0-30000,latest.cost.net_price.public.by_income_level.30001-48000,latest.cost.net_price.public.by_income_level.48001-75000,latest.cost.net_price.public.by_income_level.75001-110000,latest.cost.net_price.public.by_income_level.110001-plus,latest.cost.net_price.private.by_income_level.0-30000,latest.cost.net_price.private.by_income_level.30001-48000,latest.cost.net_price.private.by_income_level.48001-75000,latest.cost.net_price.private.by_income_level.75001-110000,latest.cost.net_price.private.by_income_level.110001-plus,school.carnegie_basic,school.carnegie_undergrad,school.carnegie_size_setting,latest.cost.avg_net_price.private,latest.cost.avg_net_price.public,latest.cost.tuition.in_state,latest.cost.tuition.out_of_state,latest.aid.pell_grant_rate,latest.aid.federal_loan_rate,latest.aid.median_debt.completers.overall,latest.completion.completion_rate_4yr_150nt_pooled,latest.earnings.10_yrs_after_entry.working_not_enrolled.mean_earnings,school.religious_affiliation,latest.repayment.3_yr_default_rate"]) {
        
        var parameters = [
            "api_key": apiKey
        ]
        if let zipCode = zipCode, !zipCode.isEmpty {
            parameters["_zip"] = zipCode
        }
        if let distance = distanceInMile, distance > 0 {
            parameters["_distance"] = "\(distance)mi"
        }
        if let state = schoolState, !state.isEmpty {
            parameters["school.state"] = state
        }
        if let perPage = perPage, perPage > 0 {
            parameters["_per_page"] = "\(perPage)"
        }
        if let name = name, !name.isEmpty {
            parameters["school.name"] = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        if let schoolIsOperating = schoolIsOperating {
            parameters["school.operating"] = "\(schoolIsOperating)"
        }
        if let ownership = ownership {
            parameters["school.ownership"] = "\(ownership)"
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
        self.collegeList = self.collegeListInfo["results"].arrayValue
        self.testingTableJSON.reloadData()
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        guard let searchText = sender.text else { return }
        getCollegeLists(schoolIsOperating: 1, name: searchText)
    }
    
    //Dismisses keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        collegeSearchTextField.resignFirstResponder()
        return true
    }

    
}
