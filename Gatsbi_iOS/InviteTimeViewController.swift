//
//  InviteTimeViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 10/16/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

protocol InviteTimeViewControllerDelegate{
    func timeVCDidFinish(controller:InviteTimeViewController, date:NSDate, endDate:NSDate)
}

class InviteTimeViewController : UIViewController {

    var delegate:InviteTimeViewControllerDelegate? = nil
    
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
            if (delegate != nil) {
                delegate!.timeVCDidFinish(self, date: startDateTimePicker.date, endDate: endDateTimePicker.date)
            }
            //navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateTimePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        startDateTimePicker.date = myInvite!.Date.dateByAddingTimeInterval(suggestedStartTime * 60*60)
        endDateTimePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        endDateTimePicker.date = myInvite!.Date.dateByAddingTimeInterval((suggestedStartTime*60*60)+(inviteTimeHours*60*60))
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

