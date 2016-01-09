//
//  EmailSignUpViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 1/5/16.
//  Copyright © 2016 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

class EmailSignUpViewController: UIViewController {


    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBAction func dismissButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func SignUpButton(sender: UIButton) {
        //modified code from here: http://www.appcoda.com/login-signup-parse-swift/
        
        var username = self.emailAddressTextField.text
        let emailaddress = self.emailAddressTextField.text
        let password = self.passwordTextField.text
        let confirmPassword = self.confirmPasswordTextField.text

        let finalEmail = emailaddress?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Validate the text fields
        if password!.characters.count < 8 {
            let alert = UIAlertController(title: "Invalid", message: "Password must be greater than 8 characters", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(okAction);
                self.presentViewController(alert, animated:true, completion:nil);
            
        } else if emailaddress!.characters.count < 8 {
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid email address", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(okAction);
            self.presentViewController(alert, animated:true, completion:nil);
        } else if confirmPassword! != password! {
            let alert = UIAlertController(title: "Invalid", message: "Password and Confirm Password fields must match.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(okAction);
            self.presentViewController(alert, animated:true, completion:nil);
        
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            var newUser = PFUser()
            
            newUser.username = finalEmail
            newUser.password = password
            newUser.email = finalEmail
            newUser.setObject(firstNameTextField.text!, forKey: "first_name")
            newUser.setObject(lastNameTextField.text!, forKey: "last_name")

            
            // Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    let alert = UIAlertController(title: "Error", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(okAction);
                    self.presentViewController(alert, animated:true, completion:nil);
                    
                } else {
                    let alert = UIAlertController(title: "Success", message: "Signed up with Gatsbi!", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                        let setViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InviteNavigationController")
                        self.presentViewController(setViewController, animated: false, completion: nil)
                        })
                    alert.addAction(okAction);
                    self.presentViewController(alert, animated:true, completion:nil);

                    
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
