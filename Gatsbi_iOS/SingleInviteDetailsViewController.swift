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

    @IBAction func inviteRSVPStatus(sender: UIButton) {
    }
    
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
}
