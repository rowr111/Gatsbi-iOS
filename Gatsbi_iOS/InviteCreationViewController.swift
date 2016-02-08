//
//  InviteCreationViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 2/6/16.
//  Copyright © 2016 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

class InviteCreationViewController : UIViewController, InviteTimeViewControllerDelegate, HostAddressViewControllerDelegate, MenuViewControllerDelegate {
    
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
    
    @IBOutlet weak var inviteDateRange: UILabel!
    @IBOutlet weak var inviteAddress: UILabel!
    @IBOutlet weak var menuChoice: UILabel!
    
    @IBAction func timeButton(sender: UIButton) {
        self.performSegueWithIdentifier("timeSegue", sender: self)
    }
    
    @IBAction func menuButton(sender: UIButton) {
         self.performSegueWithIdentifier("menuSegue", sender: self)
    }

    @IBAction func addressButton(sender: UIButton) {
        self.performSegueWithIdentifier("addressSegue", sender: self)
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
                    tc.delegate = self
                }
                
            case "addressSegue":
                if let ac = segue.destinationViewController as? HostAddressViewController{
                    ac.myInvite = myInvite
                    ac.delegate = self
                }
            case "menuSegue":
                if let mc = segue.destinationViewController as? InviteThemesViewController{
                    mc.myInvite = myInvite
                }
            default: break
                
            }
        }
    }
    
    func timeVCDidFinish(controller: InviteTimeViewController, date:NSDate, endDate:NSDate) {
        myInvite.Date = date
        myInvite.EndDate = endDate
        controller.navigationController?.popViewControllerAnimated(true)
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .ShortStyle
        
        self.inviteDateRange.text = "\(formatter.stringFromDate(myInvite.Date)) to \r\n\(formatter.stringFromDate(myInvite.EndDate))"
        self.inviteDateRange.textColor = UIColor.whiteColor()
        self.inviteDateRange.sizeToFit()
    }
    
    func addressVCDidFinish(controller: HostAddressViewController, address:String) {
        myInvite.Address = address
        self.inviteAddress.textColor = UIColor.whiteColor()
        self.inviteAddress.text = address
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    func menuVCDidFinish(controller: MenuViewController, menu: String) {
        myInvite.MenuDescription = menu
        self.menuChoice.textColor = UIColor.whiteColor()
        self.menuChoice.text = menu
        controller.navigationController?.popToRootViewControllerAnimated(true)
    }
}