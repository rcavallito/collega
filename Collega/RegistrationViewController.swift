//
//  RegistrationViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 5/7/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.delegate = self

    }
    
    @IBAction func registerPressed(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailAddressTextField.text!, password: passwordTextField.text!) { (user, error) in

//Note to change Segue off of Register button in order to enforce Registration constraints (email and password). Keep like this for testing purposes.
            
            if error == nil{
                self.performSegue(withIdentifier: "goToWelcomeScreen", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            }

            self.textFieldShouldReturn(self.passwordTextField)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
