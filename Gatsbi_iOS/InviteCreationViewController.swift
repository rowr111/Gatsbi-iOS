//
//  InviteCreationViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 2/6/16.
//  Copyright © 2016 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

class InviteCreationViewController : UIViewController {
    
    var myInvite:Invite = Invite()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadIcons()
    }
    
    @IBAction func dismissButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var timeIcon: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var messageIcon: UIImageView!
    @IBOutlet weak var guestsIcon: UIImageView!
    
    @IBAction func timeButton(sender: UIButton) {
        self.performSegueWithIdentifier("timeSegue", sender: self)
    }
    

    func loadIcons()
    {
        timeIcon.image = IonIcons.imageWithIcon(ion_ios_time, iconColor: UIColor.whiteColor(), iconSize: 27, imageSize: CGSizeMake(30, 30))
        locationIcon.image = IonIcons.imageWithIcon(ion_ios_location, iconColor: UIColor.whiteColor(), iconSize: 27, imageSize: CGSizeMake(30, 30))
        messageIcon.image = IonIcons.imageWithIcon(ion_ios_paper, iconColor: UIColor.whiteColor(), iconSize: 27, imageSize: CGSizeMake(30, 30))
        guestsIcon.image = IonIcons.imageWithIcon(ion_ios_people, iconColor: UIColor.whiteColor(), iconSize: 27, imageSize: CGSizeMake(30, 30))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case "timeSegue":
                if let tc = segue.destinationViewController as? InviteTimeViewController{
                    tc.myInvite = myInvite
                }
            default: break
                
            }
        }
    }
}