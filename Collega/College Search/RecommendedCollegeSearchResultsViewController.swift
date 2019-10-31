//  RecommendedCollegeSearchResultsViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 9/16/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import SwiftyJSON

class RecommendedCollegeSearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var resultsTableJSON: UITableView!

    @IBOutlet weak var recommendedCollegeSearchResultsTextLabel: UILabel!
    
    let apiKey = "pzTiQAuLWx613F6yeC9Kk30q7Yn0g1tgpJdARPhM"
    let baseURL = "https://api.data.gov/ed/collegescorecard/v1/schools?"
    var finalURL = ""
    var collegeSelected = ""
    var searchParameterSchoolState = "NY"
    var searchParameterZipCode = ""
    var searchParameterSchoolDistance = ""
    var searchParameterSchoolOwnership = ""
    var ref:DatabaseReference?
    var recommendedCollegeListInfo = JSON()
    var recommendedCollegeList = [JSON]()
    var numberOfCollegesReturned = 0
    
    //This sets the number of rows in the TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return(recommendedCollegeList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "collegeDisplayCell")
        cell.textLabel?.text = recommendedCollegeList[indexPath.row]["school.name"].stringValue
        cell.detailTextLabel?.text = recommendedCollegeList[indexPath.row]["school.state"].stringValue

        return(cell)
    }
    
    //This is what happens when a row is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showDetailsVCFromRecommendedSearch", sender: indexPath)
    }
    
    
    //Sets color of background of table as well as text within tableview making it dependent on the 6-year completion rate for each school.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.96, alpha:1.0)
        
        if recommendedCollegeList[indexPath.row]["latest.completion.completion_rate_4yr_150nt_pooled"] > 0.75 {
            cell.textLabel?.textColor = UIColor(red:0.12, green:0.34, blue:0.19, alpha:1.0)
            cell.detailTextLabel?.textColor = UIColor(red:0.12, green:0.34, blue:0.19, alpha:1.0)
            cell.contentView.backgroundColor = UIColor.white
        } else if recommendedCollegeList[indexPath.row]["latest.completion.completion_rate_4yr_150nt_pooled"] > 0.50 {
            cell.textLabel?.textColor = UIColor.orange
            cell.detailTextLabel?.textColor = UIColor.orange
            cell.contentView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        } else {
            cell.textLabel?.textColor = UIColor.red
            cell.detailTextLabel?.textColor = UIColor.red
            cell.contentView.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        }
        
        //This is the original coloring I believe?
        //cell.textLabel?.textColor = UIColor(red:0.77, green:0.62, blue:0.09, alpha:1.0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Use this if I want to change the background color of the entire table
        //self.resultsTableJSON.backgroundColor = UIColor.red

        // Use this once we start to pull specific student information from Firebase
        ref = Database.database().reference()

        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                
                //Setting distance parameters on the API function
                if (json["SearchParameters"]["DistanceSearchParameters"]["RemainInState"].stringValue) == "true"
                {
                    self.searchParameterSchoolState = (json["StudentHomeState"].stringValue)
                } else if (json["SearchParameters"]["DistanceSearchParameters"]["DistanceFromHomeZipCode"].stringValue) != "" {
                    self.searchParameterSchoolState = ""
                    self.searchParameterSchoolDistance = (json["SearchParameters"]["DistanceSearchParameters"]["DistanceFromHomeZipCode"].stringValue)
                } else {
                    self.searchParameterSchoolState = ""
                    self.searchParameterSchoolDistance = ""
                }
                                
            }
            
            //By placing within the enclosure, I am able to get the correct value for searchParameterSchoolState. However I need a way to run this outside of the enclosures (this is a recurring problem in my code with various other instances).
            
            //This one works...Except if the list comes back with more than 100 ... how to solve that? Because the most the API will have on a page is 100??
            //self.getCollegeLists(schoolState: "\(self.searchParameterSchoolState)", perPage: 100, ownership: "1,2", level: "3")
            
            //Probably need to include the getCollegeLists directly into the IF/ELSE statements because of the variables ...
            
            self.getCollegeLists(schoolIsOperating: 1, zipCode: "10461", distanceInMile: 100, perPage: 367, ownership: "1,2", level: "3")
            
        })
                
        //getCollegeLists(schoolState: "\(searchParameterSchoolState)", perPage: 100, ownership: "1,2", level: "3")
                
        resultsTableJSON.delegate = self
        resultsTableJSON.dataSource = self

    }
    
    func getCollegeLists(schoolIsOperating: Int? = nil, zipCode: String? = nil, distanceInMile: Int? = nil, schoolState: String? = nil, perPage: Int? = nil, name: String? = nil, ownership: String? = nil, level: String? = nil, additionalFields: [String: String]? = ["_fields": "school.name,id,school.city,school.state,school.zip,school.school_url,school.locale,school.men_only,school.women_only,latest.admissions.admission_rate.overall,latest.admissions.sat_scores.average.overall,latest.admissions.act_scores.midpoint.cumulative,school.ownership,latest.student.size,latest.student.grad_students,latest.student.demographics.men,latest.student.demographics.women,latest.student.part_time_share,latest.student.demographics.race_ethnicity.white,latest.student.demographics.race_ethnicity.black,latest.student.demographics.race_ethnicity.hispanic,latest.student.demographics.race_ethnicity.asian,latest.student.demographics.race_ethnicity.aian,latest.student.demographics.race_ethnicity.nhpi,latest.student.demographics.race_ethnicity.two_or_more,latest.student.demographics.race_ethnicity.non_resident_alien,latest.student.demographics.race_ethnicity.unknown,latest.student.retention_rate.four_year.full_time_pooled,latest.student.retention_rate.lt_four_year.full_time_pooled,school.degrees_awarded.predominant,latest.cost.net_price.public.by_income_level.0-30000,latest.cost.net_price.public.by_income_level.30001-48000,latest.cost.net_price.public.by_income_level.48001-75000,latest.cost.net_price.public.by_income_level.75001-110000,latest.cost.net_price.public.by_income_level.110001-plus,latest.cost.net_price.private.by_income_level.0-30000,latest.cost.net_price.private.by_income_level.30001-48000,latest.cost.net_price.private.by_income_level.48001-75000,latest.cost.net_price.private.by_income_level.75001-110000,latest.cost.net_price.private.by_income_level.110001-plus,school.carnegie_basic,school.carnegie_undergrad,school.carnegie_size_setting,latest.cost.avg_net_price.private,latest.cost.avg_net_price.public,latest.cost.tuition.in_state,latest.cost.tuition.out_of_state,latest.aid.pell_grant_rate,latest.aid.federal_loan_rate,latest.aid.median_debt.completers.overall,latest.completion.completion_rate_4yr_150nt_pooled,latest.earnings.10_yrs_after_entry.working_not_enrolled.mean_earnings,school.religious_affiliation,latest.repayment.3_yr_default_rate"]) {
        
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
        if let level = level {
            parameters["school.degrees_awarded.predominant"] = "\(level)"
        }
        if let additionalFields = additionalFields {
            parameters.merge(additionalFields) { (_, current) in current }
        }
        
        let url = baseURL + buildParameterString(parameters: parameters)
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    self.recommendedCollegeListInfo = json
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
        print(finalURL)
        return parameterString
    }
    
    //MARK: - JSON Parsing
    func processCollegeList() {
        self.recommendedCollegeList = self.recommendedCollegeListInfo["results"].arrayValue
        //self.recommendedCollegeListInfo.sorted {$0.name < $1.name}
        //self.recommendedCollegeListInfo.sorted(by: >)

        self.resultsTableJSON.reloadData()
        
        //This allows me to state how many colleges are returned and include it in the text at the top of the screen.
        numberOfCollegesReturned = recommendedCollegeListInfo["metadata"]["total"].intValue
        
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.recommendedCollegeSearchResultsTextLabel.text = "Okay \(studentFirstName), here is a list of \(numberOfCollegesReturned) colleges that fit your initial search criteria:"
        }
    }
    
    //Send data forward to College Information VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsVCFromRecommendedSearch", let destVC = segue.destination as? CollegeDetailsViewController, let idxPath = sender as? IndexPath {
            destVC.selectedCollege = self.recommendedCollegeList[idxPath.row]
        }
    }
}
