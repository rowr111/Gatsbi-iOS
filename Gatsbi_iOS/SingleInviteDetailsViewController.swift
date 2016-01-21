//
//  SingleInviteDetailsViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 1/2/16.
//  Copyright © 2016 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

class SingleInviteDetailsViewController: UIViewController {
    
    var myInviteEvent:UserInviteEvent?
    var myInvite:Invite = Invite()
    
    @IBAction func dismissButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
        getInvite()
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
        
        loadAttendeeList()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getInvite()
    {
        let query = PFQuery(className:"Invite")
        if let myInviteObject = query.getObjectWithId(myInviteEvent!.InviteObjectID)
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
    
    func loadAttendeeList()
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
        if let objects = query.findObjects() {
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
                        goingCount = goingCount + 1
                        if goingCount == 1
                        { goingList = emailaddr }
                        else
                        { goingList = "\(goingList)\r\n\(emailaddr)" }
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
}
