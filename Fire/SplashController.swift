//
//  SplashController.swift
//  Fire
//
//  Created by Moogun Jung on 4/25/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

// check if a user logged in and
// 1. logged in -> presentCustomTabBarController
// 2. not logged in -> presentLoginController

class SplashController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkIfUserIsLoggedin()
    }
    
    func checkIfUserIsLoggedin() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            AppDelegate.instance?.presentCustomTabBarController()
        }
    }
    
            
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            print("signed out")
        } catch let logoutError {
            print(logoutError)
        }
        
        AppDelegate.instance?.presentLoginController()
    }
        
}

