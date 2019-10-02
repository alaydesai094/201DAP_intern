//
//  MainNavigationController.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-02-21.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationController: UINavigationController {
    
    var userObject : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dbHelper = DatabaseHelper()

        userObject = dbHelper.checkLoggedIn()
        
        if (userObject != nil){
            
            perform( #selector(MainNavigationController.showHome), with: nil, afterDelay: 0.01 )
            
        }else{
            
            perform(#selector(MainNavigationController.showLogin), with: nil, afterDelay: 0.01)
        }
        
    }
    
    @objc func showHome() {
        
        let homeController = MaintabBarViewController()
        
        present(homeController, animated: true, completion: {
            
        })
        
    }
    @objc func showLogin() {
        let login = LoginOpitonViewController()
        present(login, animated: true, completion: {
            
        })
    }
}
