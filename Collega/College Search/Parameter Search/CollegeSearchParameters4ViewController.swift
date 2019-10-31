//
//  CollegeSearchParameters4ViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 10/29/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase

class CollegeSearchParameters4ViewController: UIViewController {
    
    @IBOutlet weak var miscSearchParametersTextLabel: UILabel!
    
    
    //Variables for Misc Search Parameters, all defaulted to "false"
    var includeForProfitColleges : String = "False"
    var historicallyBlackCollegesOnly : String = "False"
    var predominatelyBlackCollegesOnly : String = "False"
    var predominatelyHispanicCollegesOnly : String = "False"
    var religiousAffiliatedCollegesOnly : String = "False"
    var mainCampusOnly : String = "False"
    var singleSexCollegesOnly : String = "False"
    
    //Creating variable for Firebase calls
    var ref:DatabaseReference?
    
    
    //Defines what happens if/when a switch is changed (default is "False")
    @IBAction func includeForProfitCollegesSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            includeForProfitColleges = "True"
        } else {
            includeForProfitColleges = "False"
        }
    }
    
    @IBAction func historicallyBlackCollegesOnlySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            historicallyBlackCollegesOnly = "True"
        } else {
            historicallyBlackCollegesOnly = "False"
        }
    }
    
    @IBAction func predominatelyBlackCollegesOnlySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            predominatelyBlackCollegesOnly = "True"
        } else {
            predominatelyBlackCollegesOnly = "False"
        }
    }
    
    @IBAction func predominatelyHispanicCollegesOnlySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            predominatelyHispanicCollegesOnly = "True"
        } else {
            predominatelyHispanicCollegesOnly = "False"
        }
    }
    
    @IBAction func religiousAffiliatedCollegesOnlySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            religiousAffiliatedCollegesOnly = "True"
        } else {
            religiousAffiliatedCollegesOnly = "False"
        }
    }
    
    @IBAction func mainCampusOnlySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            mainCampusOnly = "True"
        } else {
            mainCampusOnly = "False"
        }
    }
    
    @IBAction func singleSexCollegesOnlySwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            singleSexCollegesOnly = "True"
        } else {
            singleSexCollegesOnly = "False"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase
        ref = Database.database().reference()
        
        //Dynamic content allowing for personalization of First Name from User Defaults
        if let studentFirstName = UserDefaults.standard.object(forKey: "studentFirstName") as? String {
            self.miscSearchParametersTextLabel.text = "Next \(studentFirstName), let's go through and take a look at a few other parameters for your college search. Most of these are very specific and will not apply to you, but some might and we want to ensure you find the college best suited for you. As always, if you're unsure, then just leave the setting at the initial, recommended setting:"
        }

    }
    
    @IBAction func submitMiscSearchParametersPressed(_ sender: UIButton) {
        
        guard let curUserId = Auth.auth().currentUser?.uid else { return }
        
        let studentMiscSearchParametersPreferences = ["StudentSelectedIncludeForProfitColleges" : includeForProfitColleges, "StudentSelectedHistoricallyBlackCollegesOnly" : historicallyBlackCollegesOnly,"StudentSelectedPredominatelyBlackCollegesOnly" : predominatelyBlackCollegesOnly, "StudentSelectedPredominatelyHispanicCollegesOnly" : predominatelyHispanicCollegesOnly, "StudentSelectedReligiousAffiliatedCollegesOnly" : religiousAffiliatedCollegesOnly, "StudentSelectedMainCampusOnly" : mainCampusOnly, "StudentSelectedSingleSexCollegesOnly" : singleSexCollegesOnly] as [String : Any]
        ref?.child("Students").child(curUserId).child("StudentSearchParametersPreferences").updateChildValues(studentMiscSearchParametersPreferences)
         
         performSegue(withIdentifier: "goToMiscSearchParametersResultsViewController", sender: self)
    }
    
    

}
