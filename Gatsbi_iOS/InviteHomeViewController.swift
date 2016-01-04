//
//  InviteHomeViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 9/26/15.
//  Copyright (c) 2015 Gatsbi. All rights reserved.
//

import UIKit

class InviteHomeViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var myInviteEvents:[UserInviteEvent] = []
    var myFilteredInviteEvents:[UserInviteEvent] = []
    var myInvites:[Invite] = []
    var dates:[NSDate] = []
    var selectedDate: NSDate?
    
@IBOutlet weak var calendarView: NWCalendarView!
@IBOutlet weak var menuPopoverButton: UIBarButtonItem!
    
    var inviteDate: NSDate?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            getUserInviteEvents()
            
            for myEvent in self.myInviteEvents
            {
                // doing some conversion here because myEvent.Date will not midnight
                dates.append(NSCalendar.currentCalendar().startOfDayForDate(myEvent.Date))
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
            
            //set the popover button's image
            menuPopoverButton.image = IonIcons.imageWithIcon(ion_navicon_round, iconColor: UIColor.whiteColor(), iconSize: 40.0, imageSize: CGSizeMake(70.0, 70.0))
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
        
                let viewInvitesAction = UIAlertAction(title: "View My Invites", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                    self.myFilteredInviteEvents = self.myInviteEvents.filter({return $0.Date >= self.selectedDate && $0.Date <= self.selectedDate!.dateByAddingTimeInterval(NSTimeInterval(60*60*24)) })
                    
                    if (self.myFilteredInviteEvents.count > 1)
                    {
                        self.performSegueWithIdentifier(("viewMultiInvitesSegue"), sender: nil)
                    }
                    else
                    {
                        self.performSegueWithIdentifier("viewSingleInviteDetailSegue", sender: nil)
                    }
                })
                alertController.addAction(viewInvitesAction)
        
                let newInviteAction = UIAlertAction(title: "Create New Invite", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                    self.inviteDate = fromDate.date!
                    self.performSegueWithIdentifier("segueThemes", sender: nil)
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
                performSegueWithIdentifier("segueThemes", sender: nil)
            }
        }
        else
        {
            inviteDate = fromDate.date!
            performSegueWithIdentifier("segueThemes", sender: nil)
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
            case "segueThemes":
                    if let themes = segue.destinationViewController as? InviteThemesViewController{
                        //create a new invite, hooray!
                        themes.myInvite = Invite()
                        themes.myInvite!.Date = inviteDate!
                }
            case "viewSingleInviteDetailSegue":
                if let mySingleInviteDetail = segue.destinationViewController as? SingleInviteDetailsViewController{
                    //it should be safe to make the assumption here that there is only one event and it is there
                    mySingleInviteDetail.myInviteEvent = myFilteredInviteEvents[0]
                }
            case "viewMultiInvitesSegue":
                if let myMultiInvites = segue.destinationViewController as? MultiInviteViewController{
                    myMultiInvites.myInviteEvents = myFilteredInviteEvents
                    
                }
            default: break
                
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func getUserInviteEvents()
    {
        
        let query = PFQuery(className:"UserInviteEvent")
        if let _ = PFUser.currentUser()?.email
        {
        query.whereKey("EmailAddr", equalTo:PFUser.currentUser()!.email!)
        let objects = query.findObjects()
                print("Successfully retrieved \(objects!.count) events.")
                // Do something with the found objects
                if let objects = objects {
                   for object in objects {
                        let myInviteEvent = UserInviteEvent()
                        print(object.objectId)
                        myInviteEvent.objectId = object.objectId!!
                        myInviteEvent.InviteObjectID = object["InviteObjectID"] as! String
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
                        let query2 = PFQuery(className:"Invite")
                        if let myInvite = query2.getObjectWithId(myInviteEvent.InviteObjectID)
                        {
                                    myInviteEvent.Date = myInvite["Date"] as! NSDate
                        }

                        self.myInviteEvents.append(myInviteEvent)
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
    
    

}

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate: Comparable { }





