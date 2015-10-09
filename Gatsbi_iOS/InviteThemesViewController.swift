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
        
        if let pfObject = object {
            cell?.menuDescription?.text = pfObject["Name"] as? String
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
    

}
