//
//  InvitePicViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 10/25/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation
import UIKit


class InvitePicViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var myInvite:Invite?
    
    @IBOutlet weak var inviteImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func okButton(sender: UIButton) {
        if let validImage = self.inviteImageView.image
        {
            self.myInvite!.Image = validImage
            self.performSegueWithIdentifier("titleSegue", sender: self)
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
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let resizedImage: UIImage = pickedImage.resizedImageWithContentMode(UIViewContentMode.ScaleAspectFit, bounds: CGSizeMake(300.0, 300.0), interpolationQuality: CGInterpolationQuality.High)
            //inviteImageView.contentMode = .ScaleAspectFit
            inviteImageView.image = resizedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case "titleSegue":
                if let titleController = segue.destinationViewController as? InviteTitleViewController{
                    self.myInvite!.Image = inviteImageView.image!
                    //pass along the invite, including the new invite pic!
                    titleController.myInvite = myInvite!
                }
                
            default: break
            }
        }
    }

}