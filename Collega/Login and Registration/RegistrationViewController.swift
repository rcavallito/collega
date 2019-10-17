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
    
    @IBOutlet weak var studentFirstNameTextField: UITextField!
    @IBOutlet weak var studentLastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentFirstNameTextField.delegate = self
        studentLastNameTextField.delegate = self
        passwordTextField.delegate = self
        emailAddressTextField.delegate = self
    }
    
    //Action when the "Register" button is pressed
    @IBAction func registerNewUserPressed(_ sender: UIButton) {
        registerNewUser()
    }
    
    //Allows user to toggle to next Text field or executing button action by hitting Enter/Go on keyboard; also dismisses keyboard when done editing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailAddressTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            registerNewUser()
        }
        return true
    }
    
    //Function to register a new user to Firebase
    func registerNewUser() {
        Auth.auth().createUser(withEmail: emailAddressTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error == nil{
                self.performSegue(withIdentifier: "goToWelcomeScreen", sender: self)
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                }
        }
        
        //Assigns the first name and last name to User Defaults
        UserDefaults.standard.set(studentFirstNameTextField.text!, forKey: "studentFirstName")
        
        UserDefaults.standard.set(studentLastNameTextField.text!, forKey: "studentLastName")
    }
}
