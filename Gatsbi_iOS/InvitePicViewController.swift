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

class InvitePicViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate:InvitePicViewControllerDelegate? = nil
    var myInvite:Invite?
    
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
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            let resizedImage: UIImage = pickedImage.resizedImageWithContentMode(UIViewContentMode.ScaleAspectFit, bounds: CGSizeMake(200.0, 375.0), interpolationQuality: CGInterpolationQuality.High)
            //inviteImageView.contentMode = .ScaleAspectFit
            inviteImageView.image = resizedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    


}