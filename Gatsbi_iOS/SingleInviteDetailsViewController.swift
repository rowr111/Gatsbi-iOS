//
//  SingleInviteDetailsViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 1/2/16.
//  Copyright © 2016 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

class SingleInviteDetailsViewController: UIViewController, InviteRSVPViewControllerDelegate {
    
    var myInviteEvent:UserInviteEvent?
    var myInvite:Invite = Invite()
    
    @IBAction func dismissButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var rsvpNoButton: UIButton!
    @IBOutlet weak var rsvpYesButton: UIButton!
    @IBOutlet weak var timeIcon: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var messageIcon: UIImageView!
    @IBOutlet weak var guestsIcon: UIImageView!
    
    @IBOutlet weak var inviteImage: UIImageView!
    @IBOutlet weak var inviteDateRange: UILabel!
    @IBOutlet weak var inviteAddress: UILabel!
    @IBOutlet weak var inviteMessage: UILabel!
    
    @IBOutlet weak var inviteTitleLabel: UILabel!
    
    @IBOutlet weak var goingLabel: UILabel!
    @IBOutlet weak var goingList: UILabel!
    @IBOutlet weak var notRespondedLabel: UILabel!
    @IBOutlet weak var notRespondedList: UILabel!
    @IBOutlet weak var notGoingLabel: UILabel!
    @IBOutlet weak var notGoingList: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadIcons()
        print(myInviteEvent!.InviteObjectID)
        try! getInvite()
        self.inviteImage.image = myInvite.Image
        self.inviteTitleLabel.text = myInvite.Title
        self.inviteAddress.text = myInvite.Address
        self.inviteMessage.text = myInvite.Message
        self.inviteAddress.text = myInvite.Address
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .ShortStyle
        
        self.inviteDateRange.text = "\(formatter.stringFromDate(myInvite.Date)) to \r\n\(formatter.stringFromDate(myInvite.EndDate))"
        self.inviteDateRange.sizeToFit()
        
        try! loadAttendeeList()
        highlightRSVPButtons()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getInvite() throws
    {
        let query = PFQuery(className:"Invite")
        let myInviteObject = try query.getObjectWithId(myInviteEvent!.InviteObjectID)
        if myInviteObject.objectId == myInviteEvent!.InviteObjectID
        {
            myInvite.PopulateFromPFObjectInvite(myInviteObject)
        }
    }
    
    func loadIcons()
    {
        timeIcon.image = IonIcons.imageWithIcon(ion_ios_time, iconColor: UIColor.whiteColor(), iconSize: 27, imageSize: CGSizeMake(30, 30))
        locationIcon.image = IonIcons.imageWithIcon(ion_ios_location, iconColor: UIColor.whiteColor(), iconSize: 27, imageSize: CGSizeMake(30, 30))
        messageIcon.image = IonIcons.imageWithIcon(ion_ios_paper, iconColor: UIColor.whiteColor(), iconSize: 27, imageSize: CGSizeMake(30, 30))
        guestsIcon.image = IonIcons.imageWithIcon(ion_ios_people, iconColor: UIColor.whiteColor(), iconSize: 27, imageSize: CGSizeMake(30, 30))
    }
    
    func loadAttendeeList() throws
    {
        var goingCount:Int = 0
        var notGoingCount:Int = 0
        var notRespondedCount:Int = 0
        var goingList:String = ""
        var notGoingList:String = ""
        var notRespondedList:String = ""
        var emailaddr:String = ""
        
        let query = PFQuery(className:"UserInviteEvent")
        query.whereKey("InviteObjectID", equalTo: self.myInviteEvent!.InviteObjectID)
        let objects = try query.findObjects()
        if (objects.count > 0)
        {
            print("found \(objects.count) number of invites")
            for inviteEvent in objects {
                if let myemailaddr=inviteEvent["EmailAddr"] as? String
                {
                    print(myemailaddr)
                    emailaddr = myemailaddr
                }
                else
                { emailaddr = "Mystery Guest" }
                if let host=inviteEvent["Host"] as? Bool
                {
                    if host {emailaddr = "\(emailaddr) (Host)"}
                }
                if let attending = inviteEvent["Attending"] as? Bool
                {
                    if (attending)
                    {
                        if let guestCount = inviteEvent["GuestCount"] as? Int
                        {
                            goingCount = goingCount + guestCount
                            if guestCount > 1
                            {
                                emailaddr = emailaddr + " (\(guestCount))"
                            }
                            if goingCount == guestCount
                            { goingList = emailaddr }
                            else
                            { goingList = "\(goingList)\r\n\(emailaddr)" }
                        }
                        else
                        {
                            goingCount = goingCount + 1
                            if goingCount == 1
                            { goingList = emailaddr }
                            else
                            { goingList = "\(goingList)\r\n\(emailaddr)" }
                        }

                    }
                    else
                    {
                        notGoingCount = notGoingCount + 1
                        if notGoingCount == 1
                        { notGoingList = emailaddr }
                        else
                        { notGoingList = "\(notGoingList)\r\n\(emailaddr)" }
                    }
                }
                else
                {
                    notRespondedCount = notRespondedCount + 1
                    if notRespondedCount == 1
                    { notRespondedList = emailaddr}
                    else
                    { notRespondedList = "\(notRespondedList)\r\n\(emailaddr)"}
                }
                self.goingLabel.text = "Going (\(goingCount))"
                self.goingList.text = goingList
                self.notRespondedLabel.text = "Not Responded (\(notRespondedCount))"
                self.notRespondedList.text = notRespondedList
                self.notGoingLabel.text = "Not Going (\(notGoingCount))"
                self.notGoingList.text = notGoingList
            }
        }
    }
    
    @IBAction func noRSVPButton(sender: UIButton) {
        if let _ = self.myInviteEvent?.RSVPd
        {
            if self.myInviteEvent!.Attending == true
            {
                try! saveNoRSVPtoParse()
                declinePopup()
            }
            //else if it's already no, do nothing..
        }
        else
        {
            try! saveNoRSVPtoParse()
            declinePopup()
        }
    }
    
    @IBAction func yesRSVPButton(sender: UIButton) {
        performSegueWithIdentifier("rsvpSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case "rsvpSegue":
                if let vc = segue.destinationViewController as? InviteRSVPViewController
                {
                    vc.myInvite = self.myInvite
                    vc.myInviteEvent = self.myInviteEvent
                    vc.delegate = self
                    
                }
            default: break
            }
        }
    }
    
    func saveNoRSVPtoParse()
    {
        let query = PFQuery(className:"UserInviteEvent")
        let parseInviteEvent = try! query.getObjectWithId(myInviteEvent!.objectId)
        if parseInviteEvent.objectId == myInviteEvent!.objectId
        {
                parseInviteEvent["Attending"] = false
                parseInviteEvent["RSVPd"] = true
                parseInviteEvent["GuestCount"] = 1
                parseInviteEvent.saveInBackground()
            }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func declinePopup()
    {
        let alertController = UIAlertController(title: "RSVP Status: No", message: "You have declined this invitation.", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
    func highlightRSVPButtons()
    {
        if let attending = myInviteEvent?.Attending
        {
            if attending == true
            {
                rsvpYesButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
                rsvpNoButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            }
            else
            {
                rsvpNoButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
                rsvpYesButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            }
        }
    
    }
    
    func myVCDidFinish(controller: InviteRSVPViewController, done: Bool, guestcount:Int) {
        if done == true
        {
            try! loadAttendeeList()
            self.myInviteEvent!.GuestCount = guestcount
        }
    }
}
