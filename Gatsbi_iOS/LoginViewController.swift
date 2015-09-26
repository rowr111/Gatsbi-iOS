//
//  LoginViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 6/7/15.
//  Copyright (c) 2015 Gatsbi. All rights reserve
//

import UIKit
class LoginViewController: UIViewController {
    
    let permissions = ["public_profile", "email", "user_friends"]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fbLoginClick(sender: UIButton) {
        if let accessToken: FBSDKAccessToken = FBSDKAccessToken.currentAccessToken() {
            PFFacebookUtils.logInInBackgroundWithAccessToken(accessToken, block: {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    println("User logged in through Facebook!")
                } else {
                    println("Uh oh. There was an error logging in.")
                }
            })
        } else {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(self.permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                } else {
                    println("User logged in through Facebook!")
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }
        }
    }


}

