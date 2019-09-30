//
//  TakingSATorACTViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 7/8/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit

class TakingSATorACTViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func nextFromTakingSATOrACTScreen(_ sender: UIButton) {
        performSegue(withIdentifier: "goToQuestionnaireCompletedFromTakingSATOrACT", sender: self)
    }
}
