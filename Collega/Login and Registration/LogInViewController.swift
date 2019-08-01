//
//  LogInViewController.swift
//  Collega
//
//  Created by Robert Cavallito on 5/7/19.
//  Copyright © 2019 Gloop Media. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailLoginTextField: UITextField!
    @IBOutlet weak var passwordLoginTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLoginTextField.delegate = self
        passwordLoginTextField.delegate = self
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        logInUser()
}
    
        //Allows user to toggle to next Text field or perform function by hitting Enter/Go on keyboard, then dismisses keyboard when done editing
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == emailLoginTextField {
                passwordLoginTextField.becomeFirstResponder()
            } else {
            passwordLoginTextField.resignFirstResponder()
            logInUser()
            }
            return true
        }
    
    //Function to login a user
    func logInUser() {
        Auth.auth().signIn(withEmail: emailLoginTextField.text!, password: passwordLoginTextField.text!) { (user, error) in
            
            if error == nil{
                self.performSegue(withIdentifier: "goToWelcomeBackScreen", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

