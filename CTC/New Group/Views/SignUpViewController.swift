//
//  SignUpViewController.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-09.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    // variables
    
    var dbHelper: DatabaseHelper!
    
    //variables
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var backToSignIn: UIButton!
    
    @IBOutlet weak var passwordMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbHelper = DatabaseHelper()
        
        // to make text field round corner
       
        nameTextField.clipsToBounds = true
        passwordTextField.clipsToBounds = true
        emailTextField.clipsToBounds = true
        nameTextField.layer.cornerRadius = 10
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        
       
        
        nameTextField.customePlaceHolder(text: "Enter Your Name", color: UIColor.blue.withAlphaComponent(0.4))
        emailTextField.customePlaceHolder(text: "Enter Your Email", color: UIColor.blue.withAlphaComponent(0.4))
        passwordTextField.customePlaceHolder(text: "Enter Your Password", color: UIColor.blue.withAlphaComponent(0.4))
        
        nameTextField.setLeftPadding(iconName: "Name")
        emailTextField.setLeftPadding(iconName: "Email")
        passwordTextField.setLeftPadding(iconName: "Password")
        
        createAccountButton.layer.cornerRadius = 10
        backToSignIn.layer.cornerRadius = 10
        
        createAccountButton.loginButton()
        backToSignIn.loginButton()
      
        
        
        // to dismiss keyboard on tap out side
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func passwordMessage(_ sender: UITextField) {
        passwordMessage.text = "Your password must contains a letter, number and a special character!! ";
    }
    
    
    // to dismiss keyboard on tap out side
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        let name = nameTextField.text!
        var email = emailTextField.text!
        email = email.lowercased()
        let password = passwordTextField.text!
        
        if(!name.isEmpty && !email.isEmpty && !password.isEmpty){
        
            let resultFlag = dbHelper.addUser(name: name, email: email, password: password)
            
            if(resultFlag == 1){
                
                showAlert(title: "Warning", message: "User Already Exist", buttonTitle: "Try Again")
                
                
            }else if (resultFlag == 2){
                
                showAlert(title: "Error", message: "Please Report an error. . .", buttonTitle: "Try Again")
                
            }else if (resultFlag == 0){
                
                performSegue(withIdentifier: "createAccountToHome", sender: self)
                
            }
            
        }
        else{
            
            print("fill the form")
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    

}
