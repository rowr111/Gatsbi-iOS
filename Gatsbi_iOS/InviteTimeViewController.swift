//
//  InviteTimeViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 10/16/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

class InviteTimeViewController : UIViewController {
    
    var myInvite:Invite?
    
    // this is a placeholder so that it doesn't start at a weird time.  prob add menu.suggestedstarttime
    let suggestedStartTime: Double = 18
    let inviteTimeHours: Double =  4
    
    @IBOutlet weak var startDateTimePicker: UIDatePicker!
    @IBOutlet weak var endDateTimePicker: UIDatePicker!
    

    @IBAction func goButton(sender: UIButton) {
        let dateComparisionResult:NSComparisonResult = startDateTimePicker.date.compare(endDateTimePicker.date)
        
        if dateComparisionResult == NSComparisonResult.OrderedDescending
        {
        let alertController = UIAlertController(title: "Invalid Dates", message: "The party can't end before it starts!", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            performSegueWithIdentifier("invitePicSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateTimePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        startDateTimePicker.date = myInvite!.Date.dateByAddingTimeInterval(suggestedStartTime * 60*60)
        endDateTimePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        endDateTimePicker.date = myInvite!.Date.dateByAddingTimeInterval((suggestedStartTime*60*60)+(inviteTimeHours*60*60))
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case "invitePicSegue":
                print("segueing to the invite photo")
                if let timeController = segue.destinationViewController as? InvitePicViewController{
                    //pass along the invite, including the date and selected menu, hooray!
                    timeController.myInvite = myInvite!
                }
                
            default: break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

