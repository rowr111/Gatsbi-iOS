//
//  InvitePreviewViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 11/17/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

class InvitePreviewViewController: UIViewController {
    
    var myInvite:Invite?
    
    @IBOutlet weak var inviteImage: UIImageView!

    @IBOutlet weak var inviteTitle: UITextView!
    
    @IBAction func okButton(sender: UIButton) {
     performSegueWithIdentifier("confirmPaySegue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteImage.image = myInvite!.Image
        inviteTitle.text = myInvite!.Title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case "confirmPaySegue":
                print("segueing to the confirm and pay screen")
                if let confirmPayController = segue.destinationViewController as? InviteConfirmPayViewController{
                    //pass along the invite, including the date and selected menu, hooray!
                    confirmPayController.myInvite = myInvite!
                }
                
            default: break
            }
        }
    }
    

}
