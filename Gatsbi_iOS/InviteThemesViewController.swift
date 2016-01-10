//
//  InviteThemesViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 10/1/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//


import UIKit
import Parse

class InviteThemesViewController : PFQueryTableViewController {
    
    var orderByAscending: Bool = true
    var orderByColumn: String = "Name"
    var myInvite:Invite?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.automaticallyAdjustsScrollViewInsets = false
        //addHeaderView()
    }
    
    func addHeaderView()
    {
    var yPosition:CGFloat = self.navigationController!.navigationBar.frame.origin.y + self.navigationController!.navigationBar.frame.size.height;
    var mainHeaderView:UIView = UIView()
    
    let mainHeaderHeight:CGFloat = 100
    //mainHeaderView.setValuesForKeysWithDictionary(<#T##keyedValues: [String : AnyObject]##[String : AnyObject]#>)
    mainHeaderView.frameForAlignmentRect(CGRectMake(0, yPosition, self.view.frame.size.width, mainHeaderHeight))
    //mainHeaderView.backgroundColor = [UIColor redColor];
    
    self.tableView.superview?.addSubview(mainHeaderView)
    self.tableView.contentInset = UIEdgeInsetsMake(yPosition + mainHeaderHeight, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right)
    }
    
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "Menu"
        self.pullToRefreshEnabled = false
        self.paginationEnabled = false
    }
    

    override func queryForTable() -> PFQuery {
        let query:PFQuery = PFQuery(className:self.parseClassName!)
        
        if(objects?.count == 0)
        {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        if orderByAscending
        {
            query.orderByAscending(orderByColumn)
        }
        else
        {
            query.orderByDescending(orderByColumn)
        }

        return query
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cellIdentifier:String = "Cell"
        
        let cell:InviteThemesCustomCell? = (tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? InviteThemesCustomCell?)!
        cell?.menuDescription.layer.zPosition = 1
        cell?.menuPrice.layer.zPosition = 2
        cell?.menuButton.layer.zPosition = 3
        
        if let pfObject = object {
            cell?.menuDescription?.text = pfObject["Name"] as? String
            cell?.menuID = pfObject.objectId!
            if let recipeList = pfObject["Recipes"] as? [String]
            {
                cell?.RecipeList = recipeList

            }
                        if let pricePP = pfObject["PricePP"] as? Double
            {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .CurrencyStyle
                // formatter.locale = NSLocale.currentLocale() // This is the default
                    cell?.menuPrice?.text = formatter.stringFromNumber(pricePP)
            }
            print(cell?.menuPrice?.text)
            if let pfimage = pfObject["Image"] as? PFFile
            {
                pfimage.getDataInBackgroundWithBlock({
                    (result, error) in
                    cell!.menuImage?.image = UIImage(data: result!)

            }
            )}
            else
            {cell!.menuImage?.image = nil}

        }
        return cell;
    }
    
    @IBAction func sortByPrice(sender: UIButton) {
        orderByColumn = "PricePP"
        self.loadObjects()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case "menuSegue":
                print("trying to segue")
                if let menu = segue.destinationViewController as? MenuViewController{
                    //pass along the invite, including the date and selected menu, hooray!
                    menu.myInvite = myInvite!
                    let button = sender as! UIButton
                    let view = button.superview!
                    let cell = view.superview as! InviteThemesCustomCell
                    menu.myInvite?.MenuID = cell.menuID
                    menu.myInvite?.MenuDescription = cell.menuDescription.text!
                    menu.myInvite?.PricePP = cell.menuPrice.text!
                    menu.myInvite?.RecipeList = cell.RecipeList
                    menu.myInvite?.MenuImage = cell.menuImage?.image
                    print(menu.myInvite?.MenuID)
                    print(menu.myInvite?.Date)
                }
                
            default: break
    
            }
        }
    }
    

}
