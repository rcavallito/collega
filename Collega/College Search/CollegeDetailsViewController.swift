//
//  CollegeDetailsViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 7/11/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import SwiftyJSON

class CollegeDetailsViewController: UIViewController {
    
    var selectedCollege = JSON()
    
    //@IBOutlet weak var m_txtDetails: UITextView!
    //MARK: Header Labels
    @IBOutlet weak var m_lblName: UILabel!
    @IBOutlet weak var m_lblCity: UILabel!
    @IBOutlet weak var m_lblState: UILabel!
    @IBOutlet weak var m_lblZipCode: UILabel!
    @IBOutlet weak var m_lblURL: UILabel!
    
    var urlText : String = "www.colleg.ai"
    var initialURLText : String = "http://"
    
    //MARK: General Information Labels
    @IBOutlet weak var m_lblCollegeType: UILabel!
    @IBOutlet weak var m_lblPredominantDegreeGranted: UILabel!
    @IBOutlet weak var m_lblUndergraduateProfile: UILabel!
    @IBOutlet weak var m_lblStudentBodyType: UILabel!
    @IBOutlet weak var m_lblSize: UILabel!
    @IBOutlet weak var m_lblSetting: UILabel!
    @IBOutlet weak var m_lblReligiousAffiliation: UILabel!
    
    //MARK: Admissions Information Labels
    @IBOutlet weak var m_lblAdmissionRate: UILabel!
    @IBOutlet weak var m_lblAverageSATScore: UILabel!
    @IBOutlet weak var m_lblAverageACTScore: UILabel!
    
    //MARK: Student Body Labels
    @IBOutlet weak var m_lblUndergraduateStudentBodySize: UILabel!
    @IBOutlet weak var m_lblGraduateStudentBodySize: UILabel!
    @IBOutlet weak var m_lblPercentageFullTimeStudentBody: UILabel!
    @IBOutlet weak var m_lblPercentageFemaleStudentBody: UILabel!
    @IBOutlet weak var m_lblPercentageMaleStudentBody: UILabel!
    @IBOutlet weak var m_lblPercentageWhiteStudentBody: UILabel!
    @IBOutlet weak var m_lblPercentageBlackStudentBody: UILabel!
    @IBOutlet weak var m_lblPercentageHispanicStudentBody: UILabel!
    @IBOutlet weak var m_lblPercentageAsianStudentBody: UILabel!
    @IBOutlet weak var m_lblPercentageOtherStudentBody: UILabel!
    @IBOutlet weak var m_lblPercentageFirstYearRetentionRate: UILabel!

    //MARK: Cost and Financial Aid
    @IBOutlet weak var m_lblInStateTuition: UILabel!
    @IBOutlet weak var m_lblOutOfStateTuition: UILabel!
    @IBOutlet weak var m_lblUnder30kFamilyIncomeNetPrice: UILabel!
    @IBOutlet weak var m_lbl30kTo48kFamilyIncomeNetPrice: UILabel!
    @IBOutlet weak var m_lbl48kTo75kFamilyIncomeNetPrice: UILabel!
    @IBOutlet weak var m_lbl75kTo110kFamilyIncomeNetPrice: UILabel!
    @IBOutlet weak var m_lblOver110kFamilyIncomeNetPrice: UILabel!
    @IBOutlet weak var m_lblPercentageFederalLoans: UILabel!
    @IBOutlet weak var m_lblPercentagePellGrant: UILabel!
    @IBOutlet weak var m_lblAverageDebtStudentsWhoGraduate: UILabel!
    
    //MARK: Graduation & Post Graduation
    @IBOutlet weak var m_lblSixYearGraduationRate: UILabel!
    @IBOutlet weak var m_lblAverageIncome10YearsAfterEntry: UILabel!
    @IBOutlet weak var m_lblThreeYearStudentLoanDefaultRate: UILabel!
    
    //Image/Fav'ing a college - test, not in use
    let blankStar = UIImage(named: "star (1)")
    let filledStar = UIImage(named: "star")
    
    //let blankStar = UIImage(systemName: "heart")
    //let filledStar = UIImage(systemName: "heart.fill")
    
    @IBOutlet weak var favCollegeStar: UIButton!
    @IBAction func favoriteCollegeStarButton(_ sender: UIButton) {
        
        sender.setImage(filledStar, for: .normal)
    }
    
    
    
    //MARK: Dictionaries:
    let ownershipsDictionary = [1: "Public", 2: "Private Non-Profit", 3: "Private For-Profit"]
    let degreesGrantedDictionary = [0: "N/A", 1: "Certificate", 2: "2-Year", 3: "4-Year", 4: ""]
    
    let carnegieUndergradProfileDictionary = [-2: "N/A", 0: "N/A", 1: "Higher Part-Time", 2: "Mixed Part-Time and Full-Time", 3: "Medium Full-Time", 4: "Higher Full-Time", 5: "Higher Part-Time", 6: "Medium Full-Time", 7: "Medium Full-Time", 8: "Medium Full-Time", 9: "Medium Full-Time", 10: "Full-Time", 11: "Full-Time", 12: "Full-Time", 13: "Full-Time", 14: "Full-Time", 15: "Full-Time"]
    
    let carnegieSizeDictionary = [-2: "N/A", 0: "N/A", 1: "Very Small", 2: "Small", 3: "Medium", 4: "Large", 5: "Very Large", 6: "Very Small", 7: "Very Small", 8: "Very Small", 9: "Small", 10: "Small", 11: "Small", 12: "Medium", 13: "Medium", 14: "Medium", 15: "Large", 16: "Large", 17: "Large", 18: "Exclusively Graduate/Professional"]
    
    let schoolLocaleDictionary = [11: "Large City", 12: "Midsize City", 13: "Small City", 21: "Large Suburb", 22: "Midsize Suburb", 23: "Small Suburb", 31: "Fringe Town", 32: "Distant Town", 33: "Remote Town", 41: "Fringe Rural", 42: "Distant Rural", 43: "Remote Rural"]
    
    let religiousAffiliationDictionary = [nil: "N/A",-1: "No Religioius Affiliation / N/A", -2:"N/A / None", 22: "American Evangelical Lutheran Church", 24: "African Methodist Episcopal Zion Church", 27: "Assemblies of God Church", 28: "Brethren Church", 30: "Roman Catholic", 33: "Wisconsin Evangelical Lutheran Synod", 34: "Christ and Missionary Alliance Church", 35: "Christian Reformed Church", 36: "Evangelical Congregational Church", 37: "Evangelical Covenant Church of America", 38: "Evangelical Free Church of America", 39: "Evangelical Lutheran Church", 40: "International United Pentecostal Church", 41: "Free Will Baptist Church", 42: "Interdenominational", 43: "Mennonite Brethren Church", 44: "Moravian Church", 45: "North American Baptist", 47: "Pentecostal Holiness Church", 48: "Christian Churches and Churches of Christ", 49: "Reformed Church in America", 50: "Episcopal Church, Reformed", 51: "African Methodist Episcopal", 52: "American Baptist", 53: "American Lutheran", 54: "Baptist", 55: "Christian Methodist Episcopal", 57: "Church of God", 58: "Church of Brethren", 59: "Church of the Nazarene", 60: "Cumberland Presbyterian", 61: "Christian Church (Disciples of Christ)", 64: "Free Methodist", 65: "Friends", 66: "Presbyterian Church (USA)",67: "Lutheran Church in America", 68: "Lutheran Church - Missouri Synod", 69: "Mennonite Church", 71: "United Methodist", 73: "Protestant Episcopal", 74: "Churches of Christ", 75: "Southern Baptist", 76: "United Church of Christ", 77: "Protestant, not specified", 78: "Multiple Protestant Denomination", 79: "Other Protestant", 80: "Jewish", 81: "Reformed Presbyterian Church", 84: "United Brethren Church", 87: "Missionary Church Inc", 88: "Undenominational", 89: "Wesleyan", 91: "Greek Orthodox", 92: "Russian Orthodox", 93: "Unitarian Universalist", 94: "Latter Day Saints (Mormon Church)", 95: "Seventh Day Adventists", 97: "The Presbyterian Church in America", 99: "Other", 100: "Original Free Will Baptist", 101: "Ecumenical Christian", 102: "Evangelical Christian", 103: "Presbyterian", 105: "General Baptist", 106: "Muslim", 107: "Plymouth Brethren"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favCollegeStar.setImage(blankStar, for: .normal)
        favCollegeStar.setImage(filledStar, for: .highlighted)
        
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: Declarations for Ownership
        let ownership = ownershipsDictionary[selectedCollege["school.ownership"].intValue]
        
        //MARK: Declarations for Religious Affiliation
        let religiousAffiliation = religiousAffiliationDictionary[selectedCollege["school.religious_affiliation"].intValue]
        
        //MARK: Declarations for Degree Granted Type
        let degreesGranted = degreesGrantedDictionary[selectedCollege["school.degrees_awarded.predominant"].intValue]
        
        //MARK: Declrations for Carnegie Designations
        let carnegieUndergradProfile = carnegieUndergradProfileDictionary[selectedCollege["school.carnegie_undergrad"].intValue]
        
        let carnegieSize = carnegieSizeDictionary[selectedCollege["school.carnegie_size_setting"].intValue]
        
        let schoolLocale = schoolLocaleDictionary[selectedCollege["school.locale"].intValue]
        
        //MARK: Declarations for formatting numbers where using commas makes sense
        
        let numberFormatter = NumberFormatter()
        
        let averageSATScore = (selectedCollege["latest.admissions.sat_scores.average.overall"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedAverageSATScore = numberFormatter.string(from: NSNumber(value:averageSATScore))
        
        let numberOfUndergradStudents = (selectedCollege["latest.student.size"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedNumberOfUndergradStudents = numberFormatter.string(from: NSNumber(value:numberOfUndergradStudents))
        
        let numberOfGradStudents = (selectedCollege["latest.student.grad_students"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedNumberOfGradStudents = numberFormatter.string(from: NSNumber(value:numberOfGradStudents))
        
        let costOfInStateTuition = (selectedCollege["latest.cost.tuition.in_state"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedCostOfInStateTuition = numberFormatter.string(from: NSNumber(value:costOfInStateTuition))
        
        let costOfOutOfStateTuition = (selectedCollege["latest.cost.tuition.out_of_state"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedCostOfOutOfStateTuition = numberFormatter.string(from: NSNumber(value:costOfOutOfStateTuition))
        
        let averageNetCostPublicLessThan30 = (selectedCollege["latest.cost.net_price.public.by_income_level.0-30000"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedAverageNetCostPublicLessThan30 = numberFormatter.string(from: NSNumber(value:averageNetCostPublicLessThan30))
        
        let averageNetCostPublicBetween30And48 = (selectedCollege["latest.cost.net_price.public.by_income_level.30001-48000"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedAverageNetCostPublicBetween30And48 = numberFormatter.string(from: NSNumber(value:averageNetCostPublicBetween30And48))
        
        let averageNetCostPublicBetween48And75 = (selectedCollege["latest.cost.net_price.public.by_income_level.48001-75000"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedAverageNetCostPublicBetween48And75 = numberFormatter.string(from: NSNumber(value:averageNetCostPublicBetween48And75))
        
        let averageNetCostPublicBetween75And110 = (selectedCollege["latest.cost.net_price.public.by_income_level.75001-110000"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedAverageNetCostPublicBetween75And110 = numberFormatter.string(from: NSNumber(value:averageNetCostPublicBetween75And110))
        
        let averageNetCostPublicGreaterThan110 = (selectedCollege["latest.cost.net_price.public.by_income_level.110001-plus"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedAverageNetCostPublicGreaterThan110 = numberFormatter.string(from: NSNumber(value:averageNetCostPublicGreaterThan110))
        
        let averageNetCostPrivateLessThan30 = (selectedCollege["latest.cost.net_price.private.by_income_level.0-30000"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedAverageNetCostPrivateLessThan30 = numberFormatter.string(from: NSNumber(value:averageNetCostPrivateLessThan30))
        
        let averageNetCostPrivateBetween30And48 = (selectedCollege["latest.cost.net_price.private.by_income_level.30001-48000"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedAverageNetCostPrivateBetween30And48 = numberFormatter.string(from: NSNumber(value:averageNetCostPrivateBetween30And48))
        
        let averageNetCostPrivateBetween48And75 = (selectedCollege["latest.cost.net_price.private.by_income_level.48001-75000"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedAverageNetCostPrivateBetween48And75 = numberFormatter.string(from: NSNumber(value:averageNetCostPrivateBetween48And75))
        
        let averageNetCostPrivateBetween75And110 = (selectedCollege["latest.cost.net_price.private.by_income_level.75001-110000"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedAverageNetCostPrivateBetween75And110 = numberFormatter.string(from: NSNumber(value:averageNetCostPrivateBetween75And110))
        
        let averageNetCostPrivateGreaterThan110 = (selectedCollege["latest.cost.net_price.private.by_income_level.110001-plus"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedAverageNetCostPrivateGreaterThan110 = numberFormatter.string(from: NSNumber(value:averageNetCostPrivateGreaterThan110))
        
        let averageDebtForGraduates = (selectedCollege["latest.aid.median_debt.completers.overall"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedAverageDebtForGraduates = numberFormatter.string(from: NSNumber(value:averageDebtForGraduates))

        let averageSalaryTenYearsAfterEntry = (selectedCollege["latest.earnings.10_yrs_after_entry.working_not_enrolled.mean_earnings"].intValue)
        numberFormatter.numberStyle = .decimal
        let formattedAverageSalaryTenYearsAfterEntry = numberFormatter.string(from: NSNumber(value:averageSalaryTenYearsAfterEntry))
        
        //MARK: Publish the Headline Information
        self.m_lblName.text = (selectedCollege["school.name"].stringValue)
        self.m_lblCity.text = "\(selectedCollege["school.city"].stringValue),"
        self.m_lblState.text = (selectedCollege["school.state"].stringValue)
        self.m_lblZipCode.text = (selectedCollege["school.zip"].stringValue)
        self.m_lblURL.text = (selectedCollege["school.school_url"].stringValue)
        
        //Make the URL code clickable
        m_lblURL.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(clickURLLabel))
        tapGesture.numberOfTapsRequired = 1
        m_lblURL.addGestureRecognizer(tapGesture)
        
        //MARK: Publish the General Information
        self.m_lblCollegeType.text = "\(ownership!)"
        
        if religiousAffiliation != nil {
        self.m_lblReligiousAffiliation.text = "\(religiousAffiliation!)"
        } else {
        self.m_lblReligiousAffiliation.text = "No Religious Affiliation"
        }
        
        self.m_lblUndergraduateProfile.text = "\(carnegieUndergradProfile!)"
        self.m_lblSize.text = "\(carnegieSize!)"
        self.m_lblSetting.text = "\(schoolLocale!)"
        self.m_lblPredominantDegreeGranted.text = "\(degreesGranted!)"
        
        if (selectedCollege["school.men_only"].intValue) == 1 {
            self.m_lblStudentBodyType.text = "Men Only"
        } else if (selectedCollege["school.women_only"].intValue) == 1 {
            self.m_lblStudentBodyType.text = "Women Only"
        } else {
            self.m_lblStudentBodyType.text = "Coed"
        }
        
        //MARK: Publish the Admissions Information
        //This is to publish the acceptance rate if it is above 0%, otherwise N/A - which is assumed to mean unreported or something else...
        if selectedCollege["latest.admissions.admission_rate.overall"].doubleValue > 0.001 {
            self.m_lblAdmissionRate.text = " \(Int(selectedCollege["latest.admissions.admission_rate.overall"].doubleValue * 100))%"
        } else {
            self.m_lblAdmissionRate.text = "N/A"
        }
        
        //SAT Scores
        if selectedCollege["latest.admissions.sat_scores.average.overall"].doubleValue > 1 {
            self.m_lblAverageSATScore.text = formattedAverageSATScore
        } else {
            self.m_lblAverageSATScore.text = "N/A"
        }
        
        //ACT Scores
        if selectedCollege["latest.admissions.act_scores.midpoint.cumulative"].doubleValue > 1 {
            self.m_lblAverageACTScore.text = selectedCollege["latest.admissions.act_scores.midpoint.cumulative"].stringValue
        } else {
            self.m_lblAverageACTScore.text = "N/A"
        }
        
        
        //MARK: Publish the Student Body Information
        if (selectedCollege["latest.student.size"].intValue) > 0 {
            self.m_lblUndergraduateStudentBodySize.text = "\(formattedNumberOfUndergradStudents!)"
        } else {
            self.m_lblUndergraduateStudentBodySize.text = "N/A"
        }
        
        if (selectedCollege["latest.student.grad_students"].intValue) > 0 {
            self.m_lblGraduateStudentBodySize.text = "\(formattedNumberOfGradStudents!)"
        } else {
            self.m_lblGraduateStudentBodySize.text = "N/A"
        }
        
        if (selectedCollege["latest.student.demographics.women"].doubleValue * 100) > 0 {
            self.m_lblPercentageFemaleStudentBody.text = " \(Int(selectedCollege["latest.student.demographics.women"].doubleValue * 100))%"
        } else {
            self.m_lblPercentageFemaleStudentBody.text = "N/A"
        }
        
        if (selectedCollege["latest.student.demographics.men"].doubleValue * 100) > 0 {
            self.m_lblPercentageMaleStudentBody.text = " \(Int(selectedCollege["latest.student.demographics.men"].doubleValue * 100))%"
        } else {
            self.m_lblPercentageMaleStudentBody.text = "N/A"
        }
        
        let fullTimeStudentBodyPercentage = 1 - (selectedCollege["latest.student.part_time_share"].doubleValue)
        
        if (selectedCollege["latest.student.part_time_share"].doubleValue * 100) > 0 {
            self.m_lblPercentageFullTimeStudentBody.text = "\(Int(fullTimeStudentBodyPercentage * 100))%"
        } else {
            self.m_lblPercentageFullTimeStudentBody.text = "N/A"
        }
        
        //Publish the Demographic Information
        if (selectedCollege["latest.student.demographics.race_ethnicity.white"].doubleValue * 100) > 0 {
            self.m_lblPercentageWhiteStudentBody.text = " \(Int(selectedCollege["latest.student.demographics.race_ethnicity.white"].doubleValue * 100))%"
        } else {
            self.m_lblPercentageWhiteStudentBody.text = "N/A"
        }
        
        if (selectedCollege["latest.student.demographics.race_ethnicity.black"].doubleValue * 100) > 0 {
            self.m_lblPercentageBlackStudentBody.text = " \(Int(selectedCollege["latest.student.demographics.race_ethnicity.black"].doubleValue * 100))%"
        } else {
            self.m_lblPercentageBlackStudentBody.text = "N/A"
        }
        
        if (selectedCollege["latest.student.demographics.race_ethnicity.hispanic"].doubleValue * 100) > 0 {
            self.m_lblPercentageHispanicStudentBody.text = " \(Int(selectedCollege["latest.student.demographics.race_ethnicity.hispanic"].doubleValue * 100))%"
        } else {
            self.m_lblPercentageHispanicStudentBody.text = "N/A"
        }
        
        if (selectedCollege["latest.student.demographics.race_ethnicity.asian"].doubleValue * 100) > 0 {
            self.m_lblPercentageAsianStudentBody.text = " \(Int(selectedCollege["latest.student.demographics.race_ethnicity.asian"].doubleValue * 100))%"
        } else {
            self.m_lblPercentageAsianStudentBody.text = "N/A"
        }
        
        let percentageAIANStudentBody = selectedCollege["latest.student.demographics.race_ethnicity.aian"].doubleValue
        let percentageNHPIStudentBody = selectedCollege["latest.student.demographics.race_ethnicity.nhpi"].doubleValue
        let percentageTwoOrMoreStudentBody = selectedCollege["latest.student.demographics.race_ethnicity.two_or_more"].doubleValue
        let percentageNonResidentStudentBody = selectedCollege["latest.student.demographics.race_ethnicity.non_resident_alien"].doubleValue
        let percentageUnknownStudentBody = selectedCollege["latest.student.demographics.race_ethnicity.unknown"].doubleValue
        let percentageOtherStudentBody = percentageAIANStudentBody + percentageNHPIStudentBody + percentageTwoOrMoreStudentBody + percentageNonResidentStudentBody + percentageUnknownStudentBody
        
        if (percentageOtherStudentBody * 100) > 0 {
            self.m_lblPercentageOtherStudentBody.text = " \(Int(percentageOtherStudentBody * 100))%"
        } else {
            self.m_lblPercentageOtherStudentBody.text = "N/A"
        }
        
        if (selectedCollege["latest.student.retention_rate.four_year.full_time_pooled"].doubleValue * 100) > 0 {
            self.m_lblPercentageFirstYearRetentionRate.text = "\(Int(selectedCollege["latest.student.retention_rate.four_year.full_time_pooled"].doubleValue * 100))%"
        } else if (selectedCollege["latest.student.retention_rate.lt_four_year.full_time_pooled"].doubleValue * 100) > 0 {
            self.m_lblPercentageFirstYearRetentionRate.text = "\(Int(selectedCollege["latest.student.retention_rate.lt_four_year.full_time_pooled"].doubleValue * 100))%"
        } else {
            self.m_lblPercentageFirstYearRetentionRate.text = "N/A"
        }
        
        //MARK: Publish the Cost & Financial Aid Information
        if (selectedCollege["latest.cost.tuition.out_of_state"].intValue) > 0 {
            self.m_lblInStateTuition.text = "$\(formattedCostOfInStateTuition!)"
        } else {
            self.m_lblInStateTuition.text = "N/A"
        }
        
        self.m_lblOutOfStateTuition.text = "$\(formattedCostOfOutOfStateTuition!)"

        //This is to publish the Average Net Price, which has different JSON calls for Public or Private - removed because of detailed net price below...
//        if selectedCollege["school.ownership"].intValue == 1 {
//            self.m_lblAverageNetPrice.text = "$\(formattedAverageNetCostPublic!)"
//        } else {
//            self.m_lblAverageNetPrice.text = "$\(formattedAverageNetCostPrivate!)"
//        }
        
        if averageNetCostPublicLessThan30 > 0 {
            self.m_lblUnder30kFamilyIncomeNetPrice.text = "$\(formattedAverageNetCostPublicLessThan30!)"
        } else if averageNetCostPrivateLessThan30 > 0 {
            self.m_lblUnder30kFamilyIncomeNetPrice.text = "$\(formattedAverageNetCostPrivateLessThan30!)"
        } else {
            self.m_lblUnder30kFamilyIncomeNetPrice.text = "N/A"
        }
        
        if averageNetCostPublicBetween30And48 > 0 {
            self.m_lbl30kTo48kFamilyIncomeNetPrice.text = "$\(formattedAverageNetCostPublicBetween30And48!)"
        } else if averageNetCostPrivateBetween30And48 > 0 {
            self.m_lbl30kTo48kFamilyIncomeNetPrice.text = "$\(formattedAverageNetCostPrivateBetween30And48!)"
        } else {
            self.m_lbl30kTo48kFamilyIncomeNetPrice.text = "N/A"
        }
        
        if averageNetCostPublicBetween48And75 > 0 {
            self.m_lbl48kTo75kFamilyIncomeNetPrice.text = "$\(formattedAverageNetCostPublicBetween48And75!)"
        } else if averageNetCostPrivateBetween48And75 > 0 {
            self.m_lbl48kTo75kFamilyIncomeNetPrice.text = "$\(formattedAverageNetCostPrivateBetween48And75!)"
        } else {
            self.m_lbl48kTo75kFamilyIncomeNetPrice.text = "N/A"
        }
        
        if averageNetCostPublicBetween75And110 > 0 {
            self.m_lbl75kTo110kFamilyIncomeNetPrice.text = "$\(formattedAverageNetCostPublicBetween75And110!)"
        } else if averageNetCostPrivateBetween75And110 > 0 {
            self.m_lbl75kTo110kFamilyIncomeNetPrice.text = "$\(formattedAverageNetCostPrivateBetween75And110!)"
        } else {
            self.m_lbl75kTo110kFamilyIncomeNetPrice.text = "N/A"
        }
        
        if averageNetCostPublicGreaterThan110 > 0 {
            self.m_lblOver110kFamilyIncomeNetPrice.text = "$\(formattedAverageNetCostPublicGreaterThan110!)"
        } else if averageNetCostPrivateGreaterThan110 > 0 {
            self.m_lblOver110kFamilyIncomeNetPrice.text = "$\(formattedAverageNetCostPrivateGreaterThan110!)"
        } else {
            self.m_lblOver110kFamilyIncomeNetPrice.text = "N/A"
        }
    
        //Financial Aid
        if averageDebtForGraduates > 0 {
        self.m_lblAverageDebtStudentsWhoGraduate.text = "$\(formattedAverageDebtForGraduates!)"
        } else {
        self.m_lblAverageDebtStudentsWhoGraduate.text = "N/A"
        }
    
        if (selectedCollege["latest.aid.federal_loan_rate"].doubleValue * 100) > 0 {
            self.m_lblPercentageFederalLoans.text = " \(Int(selectedCollege["latest.aid.federal_loan_rate"].doubleValue * 100))%"
        } else {
            self.m_lblPercentageFederalLoans.text = "N/A"
        }
        
        if (selectedCollege["latest.aid.pell_grant_rate"].doubleValue * 100) > 0 {
            self.m_lblPercentagePellGrant.text = " \(Int(selectedCollege["latest.aid.pell_grant_rate"].doubleValue * 100))%"
        } else {
            self.m_lblPercentagePellGrant.text = "N/A"
        }
        
        //MARK: Graduation & Post Graduation Information
        if (selectedCollege["latest.completion.completion_rate_4yr_150nt_pooled"].doubleValue * 100) > 0 {
            self.m_lblSixYearGraduationRate.text = " \(Int(selectedCollege["latest.completion.completion_rate_4yr_150nt_pooled"].doubleValue * 100))%"
        } else {
            self.m_lblSixYearGraduationRate.text = "N/A"
        }
        
        if (selectedCollege["latest.earnings.10_yrs_after_entry.working_not_enrolled.mean_earnings"].doubleValue * 100) > 0 {
            self.m_lblAverageIncome10YearsAfterEntry.text = " \(Int(selectedCollege["latest.completion.outcome_percentage.full_time.first_time.6yr.award_pooled"].doubleValue * 100))%"
        } else {
            self.m_lblAverageIncome10YearsAfterEntry.text = "N/A"
        }
        
        if averageSalaryTenYearsAfterEntry > 0 {
            self.m_lblAverageIncome10YearsAfterEntry.text = "$\(formattedAverageSalaryTenYearsAfterEntry!)"
        } else {
            self.m_lblAverageIncome10YearsAfterEntry.text = "N/A"
        }
        
        if (selectedCollege["latest.repayment.3_yr_default_rate"].doubleValue * 100) > 0 {
            self.m_lblThreeYearStudentLoanDefaultRate.text = " \(Int(selectedCollege["latest.repayment.3_yr_default_rate"].doubleValue * 100))%"
        } else {
            self.m_lblThreeYearStudentLoanDefaultRate.text = "N/A"
        }

}
    
    //Function for what what happens when the URL label is clicked on HOW CAN I GET THIS TO DISPLAY THE URL FOR THE SELECTED COLLEGE???
    @objc func clickURLLabel() {
        
        let urlText = (selectedCollege["school.school_url"].stringValue)
        
        if let url = URL(string: initialURLText + urlText) {
            UIApplication.shared.open(url)
        }
        print("Username UILabel gets clicked")
    }
    
    //Sending text forward
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var myChancesViewController = segue.destination as! MyChancesViewController
        myChancesViewController.selectedCollegeID = selectedCollege["id"].stringValue
    }
    
    //MARK: Buttons DELETE AFTER TESTING IS DONE
    @IBAction func btnBackClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        //DELETE AFTER TESTING - This is only necessary when testing in situations where App is started before Nav Controller
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnMyChancesClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "goToMyChancesFromCollegeInformation", sender: self)
    }
    
}

//This is the text that Chris built - keep it so I know how to do this. m_txtDetails.text is the name of the UITextView created.
//        self.m_txtDetails.text = """
//        School City:\n\t\(selectedCollege["school.city"].stringValue)\n
//        Admission Rate:\n\t\(Int(selectedCollege["latest.admissions.admission_rate.overall"].doubleValue * 100))%\n
//        Ownership:\n\t\(selectedCollege["school.ownership"].stringValue)
//        Ownership:\n\t\(ownership!)
//        """
