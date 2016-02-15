//
//  InviteContactsViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 11/12/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

protocol InviteContactsViewControllerDelegate{
    func contactsVCDidFinish(controller:InviteContactsViewController)
}

class InviteContactsViewController: UIViewController, CNContactPickerDelegate, UITableViewDataSource, UITableViewDelegate {
    //some various help/methods from http://www.appcoda.com/ios-contacts-framework/
    
    var delegate:InviteContactsViewControllerDelegate? = nil
    
    var myInvite:Invite?
    var contacts = [CNContact]()


    @IBAction func okButton(sender: UIButton) {
        if (self.delegate != nil) {
            self.delegate!.contactsVCDidFinish(self)
        }
    }
    
    @IBOutlet weak var contactsTable: UITableView!
    
    //verify that email addresses are actually email addresses, otherwise dismiss them
    
    func contactPicker(picker: CNContactPickerViewController,
        didSelectContacts contacts: [CNContact]) {
            print("Selected \(contacts.count) contacts")
            for var index = 0; index < contacts.count; ++index
            {
                for emailAddress in contacts[index].emailAddresses {
                    let newinvite = InviteContact()
                    newinvite.Name = contacts[index].givenName + " " + contacts[index].familyName
                    newinvite.Email = emailAddress.value as! String
                    if (isValidEmail(newinvite.Email))
                    {
                    myInvite?.InviteContacts.append(newinvite)
                        print(emailAddress.value)
                    }
                }
            }
            contactsTable.reloadData()
    }
    
    @IBAction func pickContactsButton(sender: UIButton) {
    
        AppDelegate.getAppDelegate().requestForContactsAccess { (accessGranted) -> Void in
            if accessGranted {
        let controller = CNContactPickerViewController()
        
        controller.delegate = self
        
        controller.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0", argumentArray: nil)
        
        self.navigationController?.presentViewController(controller,
            animated: true, completion: nil)
            }
        }

    }
    
    
    @IBAction func manuallyEnterButton(sender: UIButton) {
        let alert = UIAlertController(title: "Invite Contact", message: "Enter email address", preferredStyle: .Alert)

        alert.addTextFieldWithConfigurationHandler({ (nameField) -> Void in
            nameField.placeholder = "Name"
        })
        alert.addTextFieldWithConfigurationHandler({ (emailField) -> Void in
            emailField.placeholder = "Email Address"
            emailField.keyboardType = .EmailAddress
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in
            print("you have pressed the Cancel button");
        }
        alert.addAction(cancelAction)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let newinvite = InviteContact()
            newinvite.Name = alert.textFields![0].text!
            newinvite.Email = alert.textFields![1].text!
            if (self.isValidEmail(newinvite.Email))
            {
            self.myInvite?.InviteContacts.append(newinvite)
            print(alert.textFields![1].text!)
            self.contactsTable.reloadData()
            }
            else
            {
                self.presentInvalidEmailAlert()
            }
        }))

        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = contactsTable.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text =
            myInvite!.InviteContacts[row].Name + ": " +
            myInvite!.InviteContacts[row].Email
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        
        let alertController = UIAlertController(title: "Remove Invitee", message: "Remove this contact from the invite list?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            print("you have pressed OK button");
            self.myInvite?.InviteContacts.removeAtIndex(row)
            self.contactsTable.reloadData()
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTable.delegate = self
        contactsTable.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (myInvite?.InviteContacts.count)!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }


    func presentInvalidEmailAlert()
    {
        let alertController = UIAlertController(title: "Invalid Email Address", message: "Not a valid email format.", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
    }

}