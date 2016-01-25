//
//  InviteRSVPViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 1/22/16.
//  Copyright © 2016 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

//learn about delegates here:
//http://makeapppie.com/2014/07/01/swift-swift-using-segues-and-delegates-in-navigation-controllers-part-1-the-template/

protocol InviteRSVPViewControllerDelegate{
    func myVCDidFinish(controller:InviteRSVPViewController,done:Bool, guestcount:Int)
}

class InviteRSVPViewController: UIViewController {
    var delegate:InviteRSVPViewControllerDelegate? = nil
    var myInviteEvent:UserInviteEvent?
    var myInvite:Invite = Invite()
    @IBOutlet weak var rsvpCount: UITextField!
    
    @IBAction func closeButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func rsvpButton(sender: UIButton) {
        
        if let number = Int(rsvpCount.text!)
        {
        if (number >= 1)
            {
                var query = PFQuery(className:"UserInviteEvent")
                if let parseInviteEvent = query.getObjectWithId(myInviteEvent!.objectId) {
                    parseInviteEvent["Attending"] = true
                    parseInviteEvent["RSVPd"] = true
                    parseInviteEvent["GuestCount"] = number
                    parseInviteEvent.saveInBackground()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    if (delegate != nil) {
                        delegate!.myVCDidFinish(self, done: true, guestcount: number)
                    }
                }
            }
        }
        else
        {
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid number.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
                
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //populate the guest count if it exists
        if let count = myInviteEvent?.GuestCount
        {
            rsvpCount.text = String(count)
        }
    }
}
