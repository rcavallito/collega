//
//  WhyAskingQuestionsViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 10/23/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit

class WhyAskingQuestionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func dismissWhyAskingQuestionsVC(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
