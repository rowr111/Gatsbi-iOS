//
//  EmailLoginViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 1/9/16.
//  Copyright © 2016 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

class EmailLoginViewController: UIViewController {
    
    
    @IBAction func dismissButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signInButton(sender: UIButton) {
        let username = self.emailAddressTextField.text
        let password = self.passwordTextField.text
        
        // Validate the text fields
        if username!.characters.count < 5 {
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid email address", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(okAction);
            self.presentViewController(alert, animated:true, completion:nil);
        } else if password!.characters.count < 8 {
            let alert = UIAlertController(title: "Invalid", message: "Password must be greater than 8 characters", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(okAction);
            self.presentViewController(alert, animated:true, completion:nil);
        } else {
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
        spinner.startAnimating()
        
        // Send a request to login
        PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
            
            // Stop the spinner
            spinner.stopAnimating()
            if ((user) != nil) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let setViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InviteNavigationController")
                    self.presentViewController(setViewController, animated: false, completion: nil)
                })
                
            } else if ((error) != nil) {
                let alert = UIAlertController(title: "Error", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(okAction);
                self.presentViewController(alert, animated:true, completion:nil);
            }
            else
            {
                let alert = UIAlertController(title: "Error", message: "Could not log in, please retry.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(okAction);
                self.presentViewController(alert, animated:true, completion:nil);
            
            }
        })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}