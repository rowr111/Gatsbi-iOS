//
//  Invite.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 10/10/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation

class Invite {

    var Date = NSDate(timeIntervalSinceReferenceDate: 0)
    var EndDate = NSDate(timeIntervalSinceReferenceDate: 0)
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
            print(Image?.size)
        }
        Address = PFObjectInvite["Address"] as! String
        Title = PFObjectInvite["Title"] as! String
        Message = PFObjectInvite["Message"] as! String
    }
    
    func SaveIntoParse() -> String
    {
        var creatorInviteEventID: String = ""
        let masterInvite = PFObject(className:"Invite")
        masterInvite["Title"] = self.Title
        masterInvite["Date"] = self.Date
        masterInvite["EndDate"] = self.EndDate
        masterInvite["Message"] = self.Message
        masterInvite["Address"] = self.Address
        masterInvite["MenuID"] = self.MenuID
        let imageFile = PFFile(data: UIImageJPEGRepresentation(self.Image!, 1.0)!)
        masterInvite["Image"] = imageFile
        var myNSError: NSError? = nil
        let masterInviteSaved = masterInvite.save(&myNSError)
        if masterInviteSaved == true
            {
                // The object has been saved.
                print("Invite saved in parse, GUID: " + masterInvite.objectId!)
                
                //now save the creator's userInviteEvent
                let user = PFUser.currentUser()
                let creatorInviteEvent = PFObject(className:"UserInviteEvent")
                creatorInviteEvent["InviteObjectID"] = masterInvite.objectId!
                creatorInviteEvent["EmailAddr"] = user!.email
                creatorInviteEvent["RSVPd"] = true
                creatorInviteEvent["Host"] = true
                creatorInviteEvent["Attending"] = true
                creatorInviteEvent["GuestCount"] = 1
                
                var myInviteNSError: NSError? = nil
                let creatorInviteEventSaved = creatorInviteEvent.save(&myInviteNSError)
                if creatorInviteEventSaved == true
                {
                    // The object has been saved.
                    creatorInviteEventID = creatorInviteEvent.objectId!
                    print("userInviteEvent saved in parse, GUID: " + creatorInviteEvent.objectId!)
                }
                else
                {
                    print("error saving to parse: " + (myInviteNSError?.description)!)
                }
                
                //now save all into the individual UserInviteEvents
                if self.InviteContacts.count > 0
                {
                    for index in 0...self.InviteContacts.count-1
                    {
                        let userInviteEvent = PFObject(className:"UserInviteEvent")
                        userInviteEvent["InviteObjectID"] = masterInvite.objectId!
                        userInviteEvent["EmailAddr"] = self.InviteContacts[index].Email
                        userInviteEvent["RSVPd"] = false
                        userInviteEvent["Host"] = false
                        userInviteEvent["GuestCount"] = 1
                        
                        var myUserInviteEventNSError: NSError? = nil
                        let userInviteEventSaved = userInviteEvent.save(&myUserInviteEventNSError)
                        if userInviteEventSaved == true
                        {
                            // The object has been saved.
                            print("userInviteEvent saved in parse, GUID: " + userInviteEvent.objectId!)
                        }
                        else
                        {
                            // There was a problem, check error.description
                            print("error saving to parse: " + (myUserInviteEventNSError?.description)!)
                        }
                            
                    }
                }
            }
    else {
            // There was a problem, check error.description
            print("error saving to parse: " + (myNSError.debugDescription))
        }
        return creatorInviteEventID
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