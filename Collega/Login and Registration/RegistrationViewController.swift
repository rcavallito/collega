//
//  RegistrationViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 5/7/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func registerNewUserPressed(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: emailAddressTextField.text!, password: passwordTextField.text!) { (user, error) in
            
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
