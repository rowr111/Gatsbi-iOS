//
//  MenuViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 10/8/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController : UIViewController {
    
    var myInvite:Invite?
    
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuDescription: UILabel!
    @IBOutlet weak var pricePP: UILabel!
    @IBOutlet weak var recipeList: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuImage.image = myInvite?.MenuImage
        menuDescription.text = myInvite?.MenuDescription
        pricePP.text = myInvite?.PricePP
        
       populateMenuInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func populateMenuInfo() {
        
        for recipe in myInvite!.RecipeList
        {
            let query = PFQuery(className:"Recipe")
            query.getObjectInBackgroundWithId(recipe)
            {
                (myRecipe: PFObject?, error: NSError?) -> Void in
                if error == nil && myRecipe != nil {
                    let myRecipeName = myRecipe!["Name"] as! String
                    self.recipeList.text = self.recipeList.text + myRecipeName
                    self.recipeList.text = self.recipeList.text + "\r\r"
                    //print(self.recipeList.text)
                }
                else {
                    print(error)
                }
            }
        }
    
    }
}
