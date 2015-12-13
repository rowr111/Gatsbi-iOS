//
//  InviteTitleViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 11/5/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

class InviteTitleViewController: UIViewController {

    var myInvite:Invite?
    @IBOutlet weak var inviteTitle: UITextField!
    @IBOutlet weak var inviteText: UITextView!
    
    @IBAction func okButton(sender: UIButton) {
        if (self.inviteTitle.text != "") && (self.inviteText.text != "")
        {
                self.myInvite!.Title = self.inviteTitle.text!
                self.myInvite!.Message = self.inviteText.text!
                performSegueWithIdentifier("contactsSegue", sender: self)
        }
        else
        {
            //if there is no title or body return to screen
            let alertController = UIAlertController(title: "Missing Information", message: "You must enter a title and message body.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case "contactsSegue":
                if let contactsController = segue.destinationViewController as? InviteContactsViewController{
                    contactsController.myInvite = myInvite!
                }
                
            default: break
            }
        }
    }
    
}
