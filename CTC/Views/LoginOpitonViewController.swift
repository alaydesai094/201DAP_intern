//
//  LoginOpitonViewController.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-02-01.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit



class LoginOpitonViewController: UIViewController {
    
    var userObject: User!
    
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.setGradientBackground(colorOne: Theme.gradientColor1, colorTwo: Theme.gradientColor2)
   
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        // Do any additional setup after loading the view.
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appeared")
        signUpButton.loginButton()
        signInButton.loginButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        print("View did appeared")
        
        let dbHelper = DatabaseHelper()
   
        userObject = dbHelper.checkLoggedIn()
        if (userObject != nil){
            
//            for user in dbHelper.getUser(){
//
//                userObject = user
//
//            }
            
            performSegue(withIdentifier: "loginOptionsToHome", sender: self)
//            let vc = storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
//            show(vc, sender: self)
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "loginOptionsToHome":
            let tbvc = segue.destination as! UITabBarController
            let navvc = tbvc.viewControllers![0] as! UINavigationController
            let destination = navvc.viewControllers[0] as! HomeViewController
            
            destination.userObject = userObject
        default: break
            
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
