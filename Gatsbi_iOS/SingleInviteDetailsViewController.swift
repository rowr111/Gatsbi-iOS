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
    @IBOutlet weak var inviteImage: UIImageView!
    @IBOutlet weak var inviteDateRange: UILabel!
    @IBOutlet weak var inviteHostStatus: UILabel!
    @IBOutlet weak var inviteAddress: UITextView!
    @IBOutlet weak var inviteMessage: UITextView!
    @IBOutlet weak var invitePaymentStatus: UILabel!
    @IBOutlet weak var inviteRSVPGuestCount: UILabel!
    @IBAction func inviteRSVPStatus(sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(myInviteEvent!.InviteObjectID)
        getInvite()
        self.inviteAddress.text = myInvite.Address
        self.inviteMessage.textContainer.lineFragmentPadding = 0
        self.inviteMessage.text = myInvite.Message
        self.inviteAddress.textContainer.lineFragmentPadding = 0
        self.inviteAddress.text = myInvite.Address
        self.inviteRSVPGuestCount.text = "Guests in RSVP: \(myInviteEvent!.GuestCount)"
        self.inviteHostStatus.text = "Host: \(myInviteEvent!.Host)"
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .ShortStyle
        
        self.inviteDateRange.text = "\(formatter.stringFromDate(myInvite.Date)) to \r\n\(formatter.stringFromDate(myInvite.EndDate))"
        
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
}
