//
//  LoginViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 6/7/15.
//  Copyright (c) 2015 Gatsbi. All rights reserve
//

import UIKit
class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailSignUpButton(sender: UIButton) {
        self.performSegueWithIdentifier("emailSignUpSegue", sender: self)
    }
    
    
    @IBAction func fbLoginClick(sender: UIButton) {
        //modified code and updated to swift 2.1 from this page 
        //http://swiftdeveloperblog.com/parse-login-with-facebook-account-example-in-swift/
        
        if let accessToken: FBSDKAccessToken = FBSDKAccessToken.currentAccessToken() {
            PFFacebookUtils.logInInBackgroundWithAccessToken(accessToken, block: {
                (user: PFUser?, error: NSError?) -> Void in
                if(error != nil)
                {
                    //Display an alert message
                    let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                    let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                    myAlert.addAction(okAction);
                    self.presentViewController(myAlert, animated:true, completion:nil);
                    return
                }
                print(user)
                print("Current token=\(FBSDKAccessToken.currentAccessToken().tokenString)")
                print("Current user id \(FBSDKAccessToken.currentAccessToken().userID)")
                
                let setViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InviteNavigationController")
                self.presentViewController(setViewController, animated: false, completion: nil)
            })
        } else {
            let permissions = ["public_profile", "email"]
            PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
                (user: PFUser?, error: NSError?) -> Void in
                if let user = user {
                    if user.isNew {
                        self.getFBDetails()
                    }
                    let setViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InviteNavigationController")
                    self.presentViewController(setViewController, animated: false, completion: nil)
                } else {
                    print("Uh oh. The user cancelled the Facebook login.")
                }
            })
        }
}

    func getFBDetails()
    {
        let requestParameters = ["fields": "id, email, first_name, last_name"]
        
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        
        userDetails.startWithCompletionHandler { (connection, result, error:NSError!) -> Void in
            
            if(error != nil)
            {
                //Display an alert message
                let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction);
                self.presentViewController(myAlert, animated:true, completion:nil);
                return
            }
            
            if(result != nil)
            {
                
                let userId:String = result["id"] as! String
                let userFirstName:String? = result["first_name"] as? String
                let userLastName:String? = result["last_name"] as? String
                let userEmail:String? = result["email"] as? String
                
                
                print("\(userEmail)")
                
                let myUser:PFUser = PFUser.currentUser()!
                
                // Save first name
                if(userFirstName != nil){
                    myUser.setObject(userFirstName!, forKey: "first_name")
                }
                
                //Save last name
                if(userLastName != nil){
                    myUser.setObject(userLastName!, forKey: "last_name")
                }
                
                // Save email address
                if(userEmail != nil){
                    myUser.setObject(userEmail!, forKey: "email")
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    
                    // Get Facebook profile picture
                    let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
                    let profilePictureUrl = NSURL(string: userProfile)
                    let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)

                    if(profilePictureData != nil){
                        let profileFileObject = PFFile(data:profilePictureData!)
                        myUser.setObject(profileFileObject, forKey: "profile_picture")
                    }
                    
                    myUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        
                        if(error != nil)
                        {
                            //Display an alert message
                            let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                            let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                            myAlert.addAction(okAction);
                            self.presentViewController(myAlert, animated:true, completion:nil);
                            return
                        }
                        
                        if(success){
                            print("User details are now updated")
                        }
                        
                    })
                }
            }
        }
    }
    
}

