//
//  SearchParametersResultsViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 10/29/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import SwiftyJSON

class SearchParametersResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var parameterSearchResultsTableJSON: UITableView!
    
    @IBOutlet weak var searchParametersResultsTextLabel: UILabel!
    
    //Variables to build the API call
    let apiKey = "pzTiQAuLWx613F6yeC9Kk30q7Yn0g1tgpJdARPhM"
    let baseURL = "https://api.data.gov/ed/collegescorecard/v1/schools?"
    var finalURL = ""
    
    //Variables for the search parameters provided by the students in the prior screens
    var publicOrPrivateCollege = ""
    var twoYearOrFourYearCollege = ""
    var residentialOrCommuterCampus = ""
    var fullTimeOrPartTime = ""
    
    var collegeSize = ""
    var collegeSetting = ""
    
    
    var searchParameterSchoolState = "NY"
    var searchParameterZipCode = "10461"
    var searchParameterSchoolDistance = ""
    var numberOfCollegesReturned = 0
    
    //Creating variables for the JSON data that comes down as part of the API call
    var searchParametersCollegeListInfo = JSON()
    var searchParametersCollegeList = [JSON]()
    
    //Creating variable for Firebase calls
    var ref:DatabaseReference?

    
    //Set the number of rows in the TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //return(recommendedCollegeList.count)
        return(searchParametersCollegeList.count)
    }
    
    //Set the School Name and School State values for the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "collegeDisplayCell")
        cell.textLabel?.text = searchParametersCollegeList[indexPath.row]["school.name"].stringValue
        cell.detailTextLabel?.text = searchParametersCollegeList[indexPath.row]["school.state"].stringValue

        return(cell)
    }
    
    //This is what happens when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showDetailsVCFromParametersSearch", sender: indexPath)
    }
    
    
    //Sets color of background of table as well as text within tableview making it dependent on the 6-year completion rate for each school.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.96, alpha:1.0)
        
        if searchParametersCollegeList[indexPath.row]["latest.completion.completion_rate_4yr_150nt_pooled"] > 0.75 {
            cell.textLabel?.textColor = UIColor(red:0.12, green:0.34, blue:0.19, alpha:1.0)
            cell.detailTextLabel?.textColor = UIColor(red:0.12, green:0.34, blue:0.19, alpha:1.0)
            cell.contentView.backgroundColor = UIColor.white
        } else if searchParametersCollegeList[indexPath.row]["latest.completion.completion_rate_4yr_150nt_pooled"] > 0.50 {
            cell.textLabel?.textColor = UIColor.orange
            cell.detailTextLabel?.textColor = UIColor.orange
            cell.contentView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        } else {
            cell.textLabel?.textColor = UIColor.red
            cell.detailTextLabel?.textColor = UIColor.red
            cell.contentView.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        }
                
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase
        ref = Database.database().reference()
        
        //
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref!.child("Students").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                let json = JSON(value)
                
                //Set Ownership parameter in getCollegeLists function
                if (json["StudentSearchParametersPreferences"]["StudentSelectedPublicOrPrivate"].stringValue) == "Any" {
                    self.publicOrPrivateCollege = "1,2"
                } else if (json["StudentSearchParametersPreferences"]["StudentSelectedPublicOrPrivate"].stringValue) == "Public"  {
                    self.publicOrPrivateCollege = "1"
                } else if (json["StudentSearchParametersPreferences"]["StudentSelectedPublicOrPrivate"].stringValue) == "Private" {
                    self.publicOrPrivateCollege = "2"
                }
                
                //Set Level (2-year or 4-year) parameter in getCollegeLists function (2 = associates, 3 = bachelors)
                if (json["StudentSearchParametersPreferences"]["StudentSelected2YearOr4Year"].stringValue) == "Any" {
                    self.twoYearOrFourYearCollege = "2,3"
                } else if (json["StudentSearchParametersPreferences"]["StudentSelected2YearOr4Year"].stringValue) == "4-Year" {
                    self.twoYearOrFourYearCollege = "3"
                } else if (json["StudentSearchParametersPreferences"]["StudentSelected2YearOr4Year"].stringValue) == "2-Year" {
                    self.twoYearOrFourYearCollege = "2"
                    }
                
                //Set Residential or Commuter parameter in getCollegeLists function
                if (json["StudentSearchParametersPreferences"]["StudentSelectedResidentialOrCommuter"].stringValue) == "Any" {
                    self.residentialOrCommuterCampus = "-2..17"
                } else if (json["StudentSearchParametersPreferences"]["StudentSelectedResidentialOrCommuter"].stringValue) == "Residential" {
                    self.residentialOrCommuterCampus = "7,8,10,11,13,14,16,17"
                } else if (json["StudentSearchParametersPreferences"]["StudentSelectedResidentialOrCommuter"].stringValue) == "Commuter" {
                    self.residentialOrCommuterCampus = "6,9,12,15"
                }
                
                //Set Full Time vs Part Time parameter in getCollegeLists function
                if (json["StudentSearchParametersPreferences"]["StudentSelectedFullTimeOrPartTime"].stringValue) == "Any" {
                    self.fullTimeOrPartTime = "-2..15"
                } //finish here with else if...
                
                
                
                //Set Size (Small, Medium or Large) parameter in getCollegeLists function
                if (json["StudentSearchParametersPreferences"]["StudentSelectedCollegeSize"].stringValue) == "Any" {
                    self.collegeSize = "0..100000"
                } else if (json["StudentSearchParametersPreferences"]["StudentSelectedCollegeSize"].stringValue) == "Small" {
                    self.collegeSize = "0..2000"
                } else if (json["StudentSearchParametersPreferences"]["StudentSelectedCollegeSize"].stringValue) == "Medium" {
                    self.collegeSize = "2000..15000"
                } else if (json["StudentSearchParametersPreferences"]["StudentSelectedCollegeSize"].stringValue) == "Large" {
                    self.collegeSize = "15000..100000"
                }
                
                //Set Setting (Rural, Suburban or Urban)
                if (json["StudentSearchParametersPreferences"]["StudentSelectedCollegeSetting"].stringValue) == "Any" {
                    self.collegeSetting = "1..43"
                } else if (json["StudentSearchParametersPreferences"]["StudentSelectedCollegeSetting"].stringValue) == "Urban" {
                    self.collegeSetting = "1..13"
                } else if (json["StudentSearchParametersPreferences"]["StudentSelectedCollegeSetting"].stringValue) == "Suburban" {
                    self.collegeSetting = "14..32"
                } else if (json["StudentSearchParametersPreferences"]["StudentSearchParametersPreferences"].stringValue) == "Rural" {
                    self.collegeSetting = "33..43"
                }
                
                
                            
                
            }
            
            self.getCollegeLists(schoolIsOperating: 1, perPage: 100, ownership: self.publicOrPrivateCollege, level: self.twoYearOrFourYearCollege, residentialOrCommuter: self.residentialOrCommuterCampus, fullTimeOrPartTime: self.fullTimeOrPartTime, size: self.collegeSize, setting: self.collegeSetting)

        })
    
    }
    
    func getCollegeLists(schoolIsOperating: Int? = nil, perPage: Int? = nil, ownership: String? = nil, level: String? = nil, residentialOrCommuter: String? = nil, fullTimeOrPartTime: String? = nil, size: String? = nil, setting: String? = nil, zipCode: String? = nil, distanceInMile: Int? = nil, schoolState: String? = nil,  name: String? = nil, additionalFields: [String: String]? = ["_fields": "school.name,id,school.city,school.state,school.zip,school.school_url,school.locale,school.men_only,school.women_only,latest.admissions.admission_rate.overall,latest.admissions.sat_scores.average.overall,latest.admissions.act_scores.midpoint.cumulative,school.ownership,latest.student.size,latest.student.grad_students,latest.student.demographics.men,latest.student.demographics.women,latest.student.part_time_share,latest.student.demographics.race_ethnicity.white,latest.student.demographics.race_ethnicity.black,latest.student.demographics.race_ethnicity.hispanic,latest.student.demographics.race_ethnicity.asian,latest.student.demographics.race_ethnicity.aian,latest.student.demographics.race_ethnicity.nhpi,latest.student.demographics.race_ethnicity.two_or_more,latest.student.demographics.race_ethnicity.non_resident_alien,latest.student.demographics.race_ethnicity.unknown,latest.student.retention_rate.four_year.full_time_pooled,latest.student.retention_rate.lt_four_year.full_time_pooled,school.degrees_awarded.predominant,latest.cost.net_price.public.by_income_level.0-30000,latest.cost.net_price.public.by_income_level.30001-48000,latest.cost.net_price.public.by_income_level.48001-75000,latest.cost.net_price.public.by_income_level.75001-110000,latest.cost.net_price.public.by_income_level.110001-plus,latest.cost.net_price.private.by_income_level.0-30000,latest.cost.net_price.private.by_income_level.30001-48000,latest.cost.net_price.private.by_income_level.48001-75000,latest.cost.net_price.private.by_income_level.75001-110000,latest.cost.net_price.private.by_income_level.110001-plus,school.carnegie_basic,school.carnegie_undergrad,school.carnegie_size_setting,latest.cost.avg_net_price.private,latest.cost.avg_net_price.public,latest.cost.tuition.in_state,latest.cost.tuition.out_of_state,latest.aid.pell_grant_rate,latest.aid.federal_loan_rate,latest.aid.median_debt.completers.overall,latest.completion.completion_rate_4yr_150nt_pooled,latest.earnings.10_yrs_after_entry.working_not_enrolled.mean_earnings,school.religious_affiliation,latest.repayment.3_yr_default_rate"]) {
            
            var parameters = [
                "api_key": apiKey
            ]
            
            //First VC parameters:
            if let schoolIsOperating = schoolIsOperating {
                parameters["school.operating"] = "\(schoolIsOperating)"
            }
            if let perPage = perPage, perPage > 0 {
                parameters["_per_page"] = "\(perPage)"
            }
            if let ownership = ownership {
                parameters["school.ownership"] = "\(ownership)"
            }
            if let level = level {
                parameters["school.degrees_awarded.predominant"] = "\(level)"
            }
            if let residentialOrCommuter = residentialOrCommuter {
            parameters["school.carnegie_size_setting"] = "\(residentialOrCommuter)"
            }
            if let fullTimeOrPartTime = fullTimeOrPartTime {
                parameters["school.carnegie_undergrad"] = "\(fullTimeOrPartTime)"
            }
            if let size = size {
                parameters["latest.student.size__range"] = "\(size)"
            }
            if let setting = setting {
                parameters["school.locale__range"] = "\(setting)"
            }
        
        
        
            if let zipCode = zipCode, !zipCode.isEmpty {
                parameters["_zip"] = zipCode
            }
            if let distance = distanceInMile, distance > 0 {
                parameters["_distance"] = "\(distance)mi"
            }
            if let state = schoolState, !state.isEmpty {
                parameters["school.state"] = state
            }
            
            if let name = name, !name.isEmpty {
                parameters["school.name"] = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            }
            if let additionalFields = additionalFields {
                parameters.merge(additionalFields) { (_, current) in current }
            }
            
            let url = baseURL + buildParameterString(parameters: parameters)
            
            Alamofire.request(url, method: .get)
                .responseJSON { response in
                    if response.result.isSuccess {
                        let json = JSON(response.result.value!)
                        self.searchParametersCollegeListInfo = json
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
            self.searchParametersCollegeList = self.searchParametersCollegeListInfo["results"].arrayValue

            self.parameterSearchResultsTableJSON.reloadData()
            
            //This allows me to state how many colleges are returned and include it in the text at the top of the screen.
            numberOfCollegesReturned = searchParametersCollegeListInfo["metadata"]["total"].intValue
            
            //This has to be here because otherwise the numberOfCollegesReturned doesn't work. HOW TO GET THIS TO WORK IN VIEWDIDLOAD??
            if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
                self.searchParametersResultsTextLabel.text = "Okay \(studentFirstName), here is a list of \(numberOfCollegesReturned) colleges that fit your search criteria:"
            }
        }
        
        //Send data forward to College Information VC
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showDetailsVCFromParametersSearch", let destVC = segue.destination as? CollegeDetailsViewController, let idxPath = sender as? IndexPath {
                destVC.selectedCollege = self.searchParametersCollegeList[idxPath.row]
            }
        }
    }
