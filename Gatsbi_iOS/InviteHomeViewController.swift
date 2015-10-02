//
//  InviteHomeViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 9/26/15.
//  Copyright (c) 2015 Gatsbi. All rights reserved.
//

import UIKit
class InviteHomeViewController: UIViewController {

// Do any additional setup after loading the view, typically from a nib.
        
    @IBAction func LogOutButton(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.loginSetup()
       
    }
@IBOutlet weak var calendarView: NWCalendarView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            calendarView.layer.borderWidth = 1
            calendarView.layer.borderColor = UIColor.lightGrayColor().CGColor
            calendarView.backgroundColor = UIColor.whiteColor()
            
            
            let date = NSDate()
            let newDate = date.dateByAddingTimeInterval(60*60*24*8)
            let newDate2 = date.dateByAddingTimeInterval(60*60*24*9)
            let newDate3 = date.dateByAddingTimeInterval(60*60*24*30)
            calendarView.disabledDates = [newDate, newDate2, newDate3]
            calendarView.selectionRangeLength = 1
            calendarView.maxMonths = 6
            calendarView.delegate = self
            calendarView.createCalendar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func loginSetup() {
        if (PFUser.currentUser() == nil) {
            let setViewController = storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
            self.presentViewController(setViewController, animated: false, completion: nil)
        }
        
        
    }
    
    
}
extension InviteHomeViewController: NWCalendarViewDelegate {
    func didChangeFromMonthToMonth(fromMonth: NSDateComponents, toMonth: NSDateComponents) {
        print("Change From month \(fromMonth) to month \(toMonth)")
    }
    
    func didSelectDate(fromDate: NSDateComponents, toDate: NSDateComponents) {
        print("Selected date \(fromDate.date!) to date \(toDate.date!)")
        performSegueWithIdentifier("segueThemes", sender: nil)
    }
}





