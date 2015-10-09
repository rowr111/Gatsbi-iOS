//
//  menuPopover.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 10/6/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation
import UIKit


class menuPopover: UIViewController{
    

    @IBAction func logoutButton(sender: UIButton) {
        PFUser.logOut()
        self.loginSetup()
    }
    
    @IBAction func settingsButton(sender: UIButton) {
    }
    
    @IBAction func helpButton(sender: UIButton) {
    }
    
    func loginSetup() {
        if (PFUser.currentUser() == nil) {
            let setViewController = storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
            self.presentViewController(setViewController, animated: false, completion: nil)
        }
    }
}