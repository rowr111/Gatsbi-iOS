//
//  InviteConfirmPayViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 11/21/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

class InviteConfirmPayViewController: UIViewController {
    
    var myInvite:Invite?

    
    @IBAction func payButton(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Confirm With Payment", message: "payment window will be launched here", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            print("you have pressed OK button");
            
            // save the master invite into parse:
            self.SaveIntoParse(self)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func SaveIntoParse(sender:AnyObject)
    {
        let masterInvite = PFObject(className:"Invite")
        masterInvite["Title"] = self.myInvite!.Title
        masterInvite["Date"] = self.myInvite!.Date
        masterInvite["EndDate"] = self.myInvite!.EndDate
        masterInvite["Message"] = self.myInvite!.Message
        masterInvite["Address"] = self.myInvite!.Address
        masterInvite["MenuID"] = self.myInvite!.MenuID
        masterInvite.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("Invite saved in parse, GUID: " + masterInvite.objectId!)
                
                //now save the creator's userInviteEvent
                let user = PFUser.currentUser()
                let creatorInviteEvent = PFObject(className:"UserInviteEvent")
                creatorInviteEvent["InviteObjectID"] = masterInvite.objectId!
                creatorInviteEvent["EmailAddr"] = user!.email
                creatorInviteEvent["RSVPd"] = true
                creatorInviteEvent["Host"] = true
                creatorInviteEvent["Attending"] = true
                creatorInviteEvent["GuestCount"] = 1
                creatorInviteEvent.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        print("userInviteEvent saved in parse, GUID: " + creatorInviteEvent.objectId!)
                    }
                    else {
                        // There was a problem, check error.description
                        print("error saving to parse: " + (error?.description)!)
                    }
                    
                }
                
                //now save all into the individual UserInviteEvents
                if self.myInvite!.InviteContacts.count > 0
                {
                    for index in 0...self.myInvite!.InviteContacts.count-1
                    {
                        let userInviteEvent = PFObject(className:"UserInviteEvent")
                        userInviteEvent["InviteObjectID"] = masterInvite.objectId!
                        userInviteEvent["EmailAddr"] = self.myInvite!.InviteContacts[index].Email
                        userInviteEvent["RSVPd"] = false
                        userInviteEvent["Host"] = false
                        userInviteEvent["GuestCount"] = 1
                        userInviteEvent.saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    // The object has been saved.
                                    print("userInviteEvent saved in parse, GUID: " + userInviteEvent.objectId!)
                            }
                                else {
                                    // There was a problem, check error.description
                                    print("error saving to parse: " + (error?.description)!)
                            }

                        }
                    }
                }

                self.performSegueWithIdentifier("homeSegue", sender: self)

            } else {
                // There was a problem, check error.description
                print("error saving to parse: " + (error?.description)!)
            }
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
