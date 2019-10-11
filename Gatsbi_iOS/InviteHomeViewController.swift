//
//  InviteHomeViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 9/26/15.
//  Copyright (c) 2015 Gatsbi. All rights reserved.
//

import UIKit

class InviteHomeViewController: UIViewController, UIPopoverPresentationControllerDelegate, InviteCreationViewControllerDelegate {

    var myInviteEvents:[UserInviteEvent] = []
    var myFilteredInviteEvents:[UserInviteEvent] = []
    var myInvites:[Invite] = []
    var dates:[NSDate] = []
    var selectedDate: NSDate?
    var inviteChoice: Invite = Invite()
    var userInviteEventChoice: UserInviteEvent?
    
@IBOutlet weak var profilePic: UIImageView!
@IBOutlet weak var calendarView: NWCalendarView!
//@IBOutlet weak var menuPopoverButton: UIBarButtonItem!
    @IBOutlet weak var gatsbiGImage: UIImageView!
    
    @IBOutlet weak var menuPopoverButton: UIButton!
    var inviteDate: NSDate?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.makingRoundedImageProfileWithRoundedBorder()
            
            try! getUserInviteEvents()
            loadCalendar()
            
            //set the popover button's image
            let naviconimage = IonIcons.imageWithIcon(ion_navicon_round, iconColor: UIColor.whiteColor(), iconSize: 40.0, imageSize: CGSizeMake(70.0, 70.0))
            menuPopoverButton.setBackgroundImage(naviconimage, forState: .Normal)
    }
    
    func loadCalendar()
    {
        for myEvent in self.myInviteEvents
        {
            // doing some conversion here because myEvent.Date will not midnight
            let myEventDate = NSCalendar.currentCalendar().startOfDayForDate(myEvent.Date)
            if !dates.contains(myEventDate)
            {
                dates.append(myEventDate)
            }
        }
        
        calendarView.highlightedDates = dates
        print(calendarView.highlightedDates!.count)
        
        
        calendarView.layer.borderWidth = 1
        calendarView.layer.borderColor = UIColor.lightGrayColor().CGColor
        calendarView.backgroundColor = UIColor.whiteColor()
        //print(calendarView.frame.height)
        calendarView.selectionRangeLength = 1
        calendarView.maxMonths = 6
        calendarView.delegate = self
        calendarView.createCalendar()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        

    
    
    }

extension InviteHomeViewController: NWCalendarViewDelegate {
    func didChangeFromMonthToMonth(fromMonth: NSDateComponents, toMonth: NSDateComponents) {
        print("Change From month \(fromMonth) to month \(toMonth)")
    }
    
    func didSelectDate(fromDate: NSDateComponents, toDate: NSDateComponents) {
        print("Selected date \(fromDate.date!)")
        selectedDate = fromDate.date!
        //first check if there are any highlighted dates
        if let highlightedDates = self.calendarView.highlightedDates
        {
            //if so, check and see if our selected date is highlighted, if yes present controller
            if (highlightedDates.contains(fromDate.date!))
            {
                let alertController = UIAlertController(title:nil, message:nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                
                self.myFilteredInviteEvents = self.myInviteEvents.filter({return $0.Date >= self.selectedDate && $0.Date <= self.selectedDate!.dateByAddingTimeInterval(NSTimeInterval(60*60*24)) })
                
                for eachUserInviteEvent in self.myFilteredInviteEvents
                {
                    //get the invite title
                    let query = PFQuery(className:"Invite")
                    let myInviteObject = try! query.getObjectWithId(eachUserInviteEvent.InviteObjectID)
                    if myInviteObject.objectId == eachUserInviteEvent.InviteObjectID
                    {

                        self.inviteChoice.PopulateFromPFObjectInvite(myInviteObject)
                        let viewInvitesAction = UIAlertAction(title: inviteChoice.Title, style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                            self.userInviteEventChoice = eachUserInviteEvent
                            self.performSegueWithIdentifier("viewSingleInviteDetailSegue", sender: nil)
                        })
                        alertController.addAction(viewInvitesAction)

                    }
                
                }
                
                let newInviteAction = UIAlertAction(title: "Create New Invite", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                    self.inviteDate = fromDate.date!
                    self.performSegueWithIdentifier("inviteCreationViewSegue", sender: nil)
                })
                alertController.addAction(newInviteAction)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { action in
                }
                alertController.addAction(cancelAction)
        
                presentViewController(alertController, animated: true, completion: nil)
            }
            else
            {
                inviteDate = fromDate.date!
                performSegueWithIdentifier("inviteCreationViewSegue", sender: nil)
            }
        }
        else
        {
            inviteDate = fromDate.date!
            performSegueWithIdentifier("inviteCreationViewSegue", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case "menuPopoverSegue":
                if let vc = segue.destinationViewController as? menuPopover{
                    vc.preferredContentSize = CGSizeMake(150, 150)
                    if let ppc = vc.popoverPresentationController {
                        ppc.permittedArrowDirections = UIPopoverArrowDirection.Any
                        ppc.delegate = self
                    }
                }
            case "inviteCreationViewSegue":
                    if let navVC = segue.destinationViewController as? UINavigationController {
                     if let newInvite = navVC.viewControllers.first as? InviteCreationViewController{
                        //create a new invite, hooray!
                        newInvite.myInvite = Invite()
                        newInvite.myInvite.Date = inviteDate!
                        newInvite.delegate = self
                        print(newInvite.myInvite.Date)
                        }
                }
            case "viewSingleInviteDetailSegue":
                if let mySingleInviteDetail = segue.destinationViewController as? SingleInviteDetailsViewController{
                    //it should be safe to make the assumption here that there is only one event and it is there
                    mySingleInviteDetail.myInviteEvent = userInviteEventChoice
                    //mySingleInviteDetail.myInvite = inviteChoice
                    
                }
            default: break
                
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func getUserInviteEvents() throws
    {
        
        let query = PFQuery(className:"UserInviteEvent")
        if let _ = PFUser.currentUser()?.email
        {
        query.whereKey("EmailAddr", equalTo:PFUser.currentUser()!.email!)
            let objects = try! query.findObjects()
            if (objects.count > 0)
            {
                print("Successfully retrieved \(objects.count) events.")
                // Do something with the found objects
                   for object in objects {
                        let myInviteEvent = UserInviteEvent()
                        print(object.objectId)
                        myInviteEvent.objectId = object.objectId!
                        myInviteEvent.InviteObjectID = object["InviteObjectID"] as! String
                        let query2 = PFQuery(className:"Invite")
                        let myInvite = try! query2.getObjectWithId(myInviteEvent.InviteObjectID)
                        if myInvite.objectId == myInviteEvent.InviteObjectID
                        {
                            print(myInvite.objectId)
                            let checkdate =  myInvite["Date"] as! NSDate
                            if checkdate >= NSCalendar.currentCalendar().startOfDayForDate(NSDate())
                            {
                                myInviteEvent.Date = myInvite["Date"] as! NSDate
                                myInviteEvent.RSVPd = object["RSVPd"] as! Bool
                                myInviteEvent.GuestCount = object["GuestCount"] as! Int
                                if let attending = object["Attending"] as? Bool
                                {
                                    myInviteEvent.Attending = attending
                                }
                                if let paid = object["Paid"] as? Bool
                                {
                                    myInviteEvent.Paid = paid
                                }
                                myInviteEvent.Host = object["Host"] as! Bool
                                self.myInviteEvents.append(myInviteEvent)
                            }
                        }
                    }

            }
        }
        else
        {
            let alertController = UIAlertController(title: "Error", message: "Cannot get calendar events, no email address exists for this user.", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        
        }
        
    }
    
    //some notes here: http://www.appcoda.com/ios-programming-circular-image-calayer/
    private func makingRoundedImageProfileWithRoundedBorder() {
        // Making a circular image profile.
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
        
        // Making a rounded image profile.
        //self.profilePic.layer.cornerRadius = 20.0
        
        self.profilePic.clipsToBounds = true
        
        // Adding a border to the image profile
        self.profilePic.layer.borderWidth = 10.0
        self.profilePic.layer.borderColor = UIColor(red:0.831373, green:0.611765 , blue:0.176471 , alpha:1).CGColor
        
        if let pfimage = PFUser.currentUser()!.objectForKey("profile_picture") as? PFFile
        {
            pfimage.getDataInBackgroundWithBlock({
                (result, error) in
                self.profilePic.image = UIImage(data: result!)
                
                }
            )}
        //else it just goes with the default, currently Gatsbi name with grey background
    }
    
    func inviteCreationVCDidFinish(controller: InviteCreationViewController, creatorInviteEventID: String)  {
        try! AddUserInviteEvent(creatorInviteEventID)

        for myEvent in self.myInviteEvents
        {
            if myEvent.objectId == creatorInviteEventID
                {
                    let myEventDate = NSCalendar.currentCalendar().startOfDayForDate(myEvent.Date)
                    if !dates.contains(myEventDate)
                    {
                        dates.append(myEventDate)
                    }
            }
        }
        calendarView.highlightedDates = dates
        controller.dismissViewControllerAnimated(true, completion: nil)
        //self.viewDidLoad()
        //loadCalendar()
    }
    
    func AddUserInviteEvent(InviteEventObjectID:String) throws
    {
        let query = PFQuery(className:"UserInviteEvent")
        let object = try! query.getObjectWithId(InviteEventObjectID)
        
        if object.objectId == InviteEventObjectID
        {
            let myInviteEvent = UserInviteEvent()
            myInviteEvent.objectId = object.objectId!
            myInviteEvent.InviteObjectID = object["InviteObjectID"] as! String
            let query2 = PFQuery(className:"Invite")
            let myInvite = try! query2.getObjectWithId(myInviteEvent.InviteObjectID)
            if myInvite.objectId == myInviteEvent.InviteObjectID
            {
                print(myInvite.objectId)
                let checkdate =  myInvite["Date"] as! NSDate
                if checkdate >= NSCalendar.currentCalendar().startOfDayForDate(NSDate())
                {
                    myInviteEvent.Date = myInvite["Date"] as! NSDate
                    myInviteEvent.RSVPd = object["RSVPd"] as! Bool
                    myInviteEvent.GuestCount = object["GuestCount"] as! Int
                    if let attending = object["Attending"] as? Bool
                    {
                        myInviteEvent.Attending = attending
                    }
                    if let paid = object["Paid"] as? Bool
                    {
                        myInviteEvent.Paid = paid
                    }
                    myInviteEvent.Host = object["Host"] as! Bool
                    self.myInviteEvents.append(myInviteEvent)
                }
            }
        }
    }

}

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate: Comparable { }





