//
//  InviteCreationViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 2/6/16.
//  Copyright © 2016 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

protocol InviteCreationViewControllerDelegate{
    func inviteCreationVCDidFinish(controller:InviteCreationViewController, creatorInviteEventID:String)
}


class InviteCreationViewController : UIViewController, InviteTimeViewControllerDelegate, HostAddressViewControllerDelegate, MenuViewControllerDelegate, InvitePicViewControllerDelegate, InviteContactsViewControllerDelegate, UITextViewDelegate {
    
    var delegate:InviteCreationViewControllerDelegate? = nil
    
    var myInvite:Invite = Invite()
    var creatorInviteEventID:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadIcons()
        messageTextView.delegate = self
        messageTextView.text = "Add Invite Message"
        messageTextView.textContainer.lineFragmentPadding = 0;
        
        //add an indent to the add title text:
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, self.titleTextField.frame.height))
        titleTextField.leftView = paddingView
        titleTextField.leftViewMode = UITextFieldViewMode.Always
    }
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        self.myInvite.Title = titleTextField.text!
        self.myInvite.Message = messageTextView.text!
        let complete = VerifyInviteComplete()
        if complete == true
        {
            self.creatorInviteEventID = self.myInvite.SaveIntoParse()
            print(creatorInviteEventID)
            if (self.delegate != nil) {
                self.delegate!.inviteCreationVCDidFinish(self, creatorInviteEventID: creatorInviteEventID)
            }
        }
    }
    
    @IBAction func dismissButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var timeIcon: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var messageIcon: UIImageView!
    @IBOutlet weak var guestsIcon: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var inviteDateRange: UILabel!
    @IBOutlet weak var inviteAddress: UILabel!
    @IBOutlet weak var menuChoice: UILabel!
    @IBOutlet weak var invitedGuests: UILabel!
    @IBOutlet weak var menuIcon: UIImageView!
    
    @IBAction func timeButton(sender: UIButton) {
        self.performSegueWithIdentifier("timeSegue", sender: self)
    }
    
    @IBAction func menuButton(sender: UIButton) {
         self.performSegueWithIdentifier("menuSegue", sender: self)
    }

    @IBAction func addressButton(sender: UIButton) {
        self.performSegueWithIdentifier("addressSegue", sender: self)
    }
    
    @IBAction func imageButton(sender: UIButton) {
        self.performSegueWithIdentifier("imageSegue", sender: self)
    }
    @IBAction func contactsSegue(sender: UIButton) {
        self.performSegueWithIdentifier("contactsSegue", sender: self)
    }
    
    func loadIcons()
    {
        timeIcon.image = IonIcons.imageWithIcon(ion_ios_time, iconColor: UIColor.whiteColor(), iconSize: 27, imageSize: CGSizeMake(30, 30))
        locationIcon.image = IonIcons.imageWithIcon(ion_ios_location, iconColor: UIColor.whiteColor(), iconSize: 27, imageSize: CGSizeMake(30, 30))
        messageIcon.image = IonIcons.imageWithIcon(ion_ios_paper, iconColor: UIColor.whiteColor(), iconSize: 27, imageSize: CGSizeMake(30, 30))
        guestsIcon.image = IonIcons.imageWithIcon(ion_ios_people, iconColor: UIColor.whiteColor(), iconSize: 27, imageSize: CGSizeMake(30, 30))
        menuIcon.image = IonIcons.imageWithIcon(ion_ios_cart, iconColor: UIColor.whiteColor(), iconSize: 27, imageSize: CGSizeMake(30,30))
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case "timeSegue":
                if let tc = segue.destinationViewController as? InviteTimeViewController{
                    tc.myInvite = myInvite
                    tc.delegate = self
                }
                
            case "addressSegue":
                if let ac = segue.destinationViewController as? HostAddressViewController{
                    ac.myInvite = myInvite
                    ac.delegate = self
                }
            case "menuSegue":
                if let mc = segue.destinationViewController as? InviteThemesViewController{
                    mc.myInvite = myInvite
                }
            case "imageSegue":
                if let ic = segue.destinationViewController as? InvitePicViewController{                    ic.myInvite = myInvite

                    ic.delegate = self
                }
            case "contactsSegue":
                if let cc = segue.destinationViewController as? InviteContactsViewController{
                    cc.myInvite = myInvite
                    cc.delegate = self
                }
            default: break
                
            }
        }
    }
    
    func timeVCDidFinish(controller: InviteTimeViewController, date:NSDate, endDate:NSDate) {
        myInvite.Date = date
        myInvite.EndDate = endDate
        controller.navigationController?.popViewControllerAnimated(true)
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .ShortStyle
        
        self.inviteDateRange.text = "\(formatter.stringFromDate(myInvite.Date)) to \r\n\(formatter.stringFromDate(myInvite.EndDate))"
        self.inviteDateRange.textColor = UIColor.whiteColor()
        self.inviteDateRange.sizeToFit()
    }
    
    func addressVCDidFinish(controller: HostAddressViewController, address:String) {
        myInvite.Address = address
        self.inviteAddress.textColor = UIColor.whiteColor()
        self.inviteAddress.text = address
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    func menuVCDidFinish(controller: MenuViewController, menu: String) {
        myInvite.MenuDescription = menu
        self.menuChoice.textColor = UIColor.whiteColor()
        self.menuChoice.text = menu
        controller.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func imageVCDidFinish(controller: InvitePicViewController, image: UIImage){
        myInvite.Image = image
        self.imageButton.setBackgroundImage(image, forState: .Normal)
        self.imageButton.setTitle("", forState: .Normal)
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    func contactsVCDidFinish(controller: InviteContactsViewController){
        self.myInvite.InviteContacts = controller.myInvite!.InviteContacts
        self.invitedGuests.textColor = UIColor.whiteColor()
        loadInviteeList()
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    func loadInviteeList()
    {
        var emailaddr:String = ""
        var invitedList:String = ""
        var invitedCount:Int = 0
        

        for inviteContact in myInvite.InviteContacts {
            if let myemailaddr=inviteContact.Email as? String
            {
                print(myemailaddr)
                emailaddr = myemailaddr
            }
            else
            { emailaddr = "Mystery Guest" }
            
            invitedCount = invitedCount + 1
            if invitedCount == 1
            { invitedList = emailaddr }
            else
            { invitedList = "\(invitedList)\r\n\(emailaddr)" }

            self.invitedGuests.text = "Invited Guests (\(invitedCount + 1))\r\n\(PFUser.currentUser()!.email!) (Host)\r\n" + invitedList
        }

    
    }
    
    func VerifyInviteComplete() -> Bool
    {
        var complete:Bool = false
        var requiredList:[String] = []
        
        if (self.myInvite.Title == "")
        { requiredList.append("Title") }
        if (self.myInvite.Message == "")
        { requiredList.append("Invite Message") }
        if (self.myInvite.MenuDescription == "")
        { requiredList.append("Menu Choice") }
        if (self.myInvite.Date == NSDate(timeIntervalSinceReferenceDate: 0))
        { requiredList.append("Event Time") }
        if (self.myInvite.Address == "")
        { requiredList.append("Location") }
        if (self.myInvite.Image == nil)
        { requiredList.append("Invite Image") }
        if requiredList.count == 0
        { complete = true}
        else
        {
            let missingItems = requiredList.joinWithSeparator(", ")
            let alertController = UIAlertController(title: "Missing Information", message: "You are missing required items: \(missingItems)", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        return complete
    
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Add Invite Message"
        { textView.text = nil}
    }
    
    //func textViewDidEndEditing(textView: UITextView) {
      //  if textView.text.isEmpty {
        //    textView.text = "Add Invite Message"
       // }
    //}
}