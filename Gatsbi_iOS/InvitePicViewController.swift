//
//  InvitePicViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 10/25/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

protocol InvitePicViewControllerDelegate{
    func imageVCDidFinish(controller:InvitePicViewController, image: UIImage)
}

class InvitePicViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GKImagePickerDelegate {
    
    var delegate:InvitePicViewControllerDelegate? = nil
    var myInvite:Invite?
    
    //https://github.com/gekitz/GKImagePicker
    var myGKImagePicker:GKImagePicker = GKImagePicker()
    @IBOutlet weak var inviteImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func okButton(sender: UIButton) {
        if let validImage = self.inviteImageView.image
        {
            self.myInvite!.Image = validImage
            if (self.delegate != nil) {
                self.delegate!.imageVCDidFinish(self, image: validImage)
            }
        }
        else
        {
            // if there is no image, do nothing
            let alertController = UIAlertController(title: "No Image", message: "You must choose an image.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        //imagePicker.allowsEditing = true
        //imagePicker.sourceType = .PhotoLibrary
        self.myGKImagePicker.cropSize = CGSizeMake(375, 200)
        self.myGKImagePicker.delegate = self
        
        presentViewController(self.myGKImagePicker.imagePickerController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if myInvite!.Image != nil
        {inviteImageView.image = myInvite!.Image!}
        
        imagePicker.delegate = self
    }
    
    func imagePicker(imagePicker: GKImagePicker!, pickedImage image: UIImage!) {
        inviteImageView.image = image
        self.myGKImagePicker.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func useDefaultPhotoButton(sender: UIButton) {
        if myInvite!.MenuID != ""
        {
            let query = PFQuery(className: "Menu")
            if let myMenu = query.getObjectWithId(myInvite!.MenuID)
            {
                if let pfimage = myMenu["DefaultInviteImage"] as? PFFile
                {
                    let pfimagedata = pfimage.getData()
                    inviteImageView.image = UIImage(data: pfimagedata!)
                }
                else
                {
                    //if no image found for this image, tell the user
                    let alertController = UIAlertController(title: "No Image", message: "No default invite image found for this menu.", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    presentViewController(alertController, animated: true, completion: nil)
                }
            }
            else
            { //return error window, this should in theory never happen
                let alertController = UIAlertController(title: "Error", message: "Error retrieving menu.", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                presentViewController(alertController, animated: true, completion: nil)
            
            }
        }
        else
        {
            //alert them that they must choose a menu first
            let alertController = UIAlertController(title: "No Image", message: "Default images are menu specific, please select a menu first.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        
        }
        
    }

    


}