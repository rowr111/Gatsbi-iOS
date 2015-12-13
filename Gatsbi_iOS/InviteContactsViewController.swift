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

class InviteContactsViewController: UIViewController, CNContactPickerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var myInvite:Invite?
    var contacts = [CNContact]()

    @IBAction func okButton(sender: UIButton) {
          performSegueWithIdentifier("previewSegue", sender: self)
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
                    myInvite?.InviteContacts.append(newinvite)
                        print(emailAddress.value)
                }
            }
            contactsTable.reloadData()
    }
    
    @IBAction func pickContactsButton(sender: UIButton) {
    
        let controller = CNContactPickerViewController()
        
        controller.delegate = self
        
        controller.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0", argumentArray: nil)
        
        navigationController?.presentViewController(controller,
            animated: true, completion: nil)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case "previewSegue":
                print("segueing to the preview")
                if let previewController = segue.destinationViewController as? InvitePreviewViewController{
                    //pass along the invite, including the date and selected menu, hooray!
                    previewController.myInvite = myInvite!
                }
                
            default: break
            }
        }
    }

}