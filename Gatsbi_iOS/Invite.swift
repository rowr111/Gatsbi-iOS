//
//  Invite.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 10/10/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation

class Invite {

    var Date = NSDate()
    var EndDate = NSDate()
    var MenuID: String = ""
    var MenuDescription: String = ""
    var PricePP: String = ""
    var RecipeList: [String] = []
    var MenuImage: UIImage?
    var Image: UIImage?
    var Address: String = ""
    var Title: String = ""
    var Message: String = ""
    var ReplyYesMsg: String = ""
    var ReplyNoMsg: String = ""
    var InviteContacts: [InviteContact] = []
    
    init()
    {
    }
    
    func PopulateFromPFObjectInvite(PFObjectInvite:PFObject)
    {
        Date = PFObjectInvite["Date"] as! NSDate
        EndDate = PFObjectInvite["EndDate"] as! NSDate
        MenuID = PFObjectInvite["MenuID"] as! String
        if let pfimage = PFObjectInvite["Image"] as? PFFile
        {
            //doing this synchronously bc we must have it to return the complete obj
            let pfimagedata = pfimage.getData()
            Image = UIImage(data: pfimagedata!)
        }
        Address = PFObjectInvite["Address"] as! String
        Title = PFObjectInvite["Title"] as! String
        Message = PFObjectInvite["Message"] as! String
    }
    
    
}

class InviteContact {
    var Name: String = ""
    var Email: String = ""
}


class UserInviteEvent {
    var objectId: String = ""
    var InviteObjectID: String = ""
    var Date = NSDate()
    var RSVPd:Bool = false
    var Attending:Bool = false
    var Paid:Bool = false
    var Host:Bool = false
    var GuestCount:Int = 0
}