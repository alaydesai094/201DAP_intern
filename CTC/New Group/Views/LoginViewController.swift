//
//  LoginViewController.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-09.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // variables
    var dbHelper: DatabaseHelper!
    var userObjectPass: User!
    ////variables
    
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var passwordMessage: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dbHelper = DatabaseHelper()

            UserNameTextField.clipsToBounds = true
            PasswordTextField.clipsToBounds = true
            UserNameTextField.layer.cornerRadius = 10
            PasswordTextField.layer.cornerRadius = 10
 
            UserNameTextField.setLeftPadding(iconName: "Email")
            PasswordTextField.setLeftPadding(iconName: "Password")
            UserNameTextField.customePlaceHolder(text: "Enter Your Email", color: UIColor.blue.withAlphaComponent(0.4))
            PasswordTextField.customePlaceHolder(text: "Enter Your Password", color: UIColor.blue.withAlphaComponent(0.4))
            
            signInButton.layer.cornerRadius = 10
            signUpButton.layer.cornerRadius = 10
            
            signUpButton.loginButton()
            signInButton.loginButton()
        
            // to dismiss keyboard on tap out side
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
            self.view.addGestureRecognizer(tapGesture)
            
    }
    
    
   
    @IBAction func forgotPassword(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Confirm E-mail Address", message: "Enter your E-mail ID", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(action:UIAlertAction) -> Void in
            
            let dbHelper = DatabaseHelper()
            let email = alert.textFields![0].text!
           let bool = dbHelper.forgotPassword(email: alert.textFields![0].text!)
            
            if bool == true{
                
                
                
                let alert = UIAlertController(title: "Change Password", message: "Enter new Password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Change", style: .default, handler: {(action:UIAlertAction) -> Void in
                   
                    if (alert.textFields![0].text!.isEmpty && alert.textFields![1].text!.isEmpty){
                        self.showToast(message: "Please enter value in both the fields.", duration: 3.0)
                    }
                    else {
                         let resultFlag = dbHelper.updatePassword(oldEmail: email, newEmail: email, password: alert.textFields![0].text!)
                        if resultFlag == 0{
                            self.showToast(message: "Password changed", duration: 3.0)
                        }else{
                            self.showToast(message: "Something went wrong. Please try again later.", duration: 3.0)
                        }
                    
                    }
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addTextField { (textField: UITextField) in
                    textField.isSecureTextEntry = true
                    textField.placeholder = "Enter your new Password."
                    
                }
                alert.addTextField { (textField: UITextField) in
                    textField.isSecureTextEntry = true
                    textField.placeholder = "Confirm new Password."
                    
                }
            
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.showAlert(title: "Verification Failed", message: "E-mail ID doesn't found.", buttonTitle: "Try Again")
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField { (textField: UITextField) in
            textField.textContentType = .emailAddress
            textField.placeholder = "Enter Your E-mail ID"
        }
        present(alert, animated: true, completion: nil)
        
       
        
    }
    
   
    
// to dismiss keyboard on tap out side
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        UserNameTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        
    }
    
    
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        let dbHelper = DatabaseHelper()
        
        userObjectPass = dbHelper.checkLoggedIn()
        if (userObjectPass != nil){
            
            performSegue(withIdentifier: "loginToHome", sender: self)
            
        }
        
    }
 
   
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        
        view.endEditing(true)
        
        var email = UserNameTextField.text!
        email = email.lowercased()
        let password = PasswordTextField.text!
        
        let resultUsers = dbHelper.getUser()
        
        var result = false
        
        for user in resultUsers{
            
            if(user.email == email && user.password == password){
                
                userObjectPass = user
                
            result = true
                dbHelper.updateLoginStatus(status: true, email: user.email!)
                break
                
            }
        }
        
        if result {
            
                performSegue(withIdentifier: "loginToHome", sender: self)
        }
        else {
            
            showAlert(title: "Login Fail", message: "Invalid Login Credentials. . .", buttonTitle: "Try Again")
            
          
                print("no")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "loginToHome":
            let tbvc = segue.destination as! UITabBarController
            let navvc = tbvc.viewControllers![0] as! UINavigationController
            let destination = navvc.viewControllers[0] as! HomeViewController
            
            destination.userObject = userObjectPass
        default: break
            
        }
        
    }
    
    
}
