//
//  InviteHomeViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 9/26/15.
//  Copyright (c) 2015 Gatsbi. All rights reserved.
//

import UIKit

class InviteHomeViewController: UIViewController, UIPopoverPresentationControllerDelegate {

// Do any additional setup after loading the view, typically from a nib.
        
@IBOutlet weak var calendarView: NWCalendarView!
@IBOutlet weak var menuPopoverButton: UIBarButtonItem!
        
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
        print("Selected date \(fromDate.date!) to date \(toDate.date!)")
        performSegueWithIdentifier("segueThemes", sender: nil)
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
            default: break
                
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    
    
}





