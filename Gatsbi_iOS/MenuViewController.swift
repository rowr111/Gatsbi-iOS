//
//  MenuViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 10/8/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController : PFQueryTableViewController {
    
    var menuID: String
    var recipeList: [String]
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "Recipe"
        self.pullToRefreshEnabled = false
        self.paginationEnabled = false
    }
    
    override func queryForTable() -> PFQuery {
        let query:PFQuery = PFQuery(className:self.parseClassName!)
        
        if(objects?.count == 0)
        {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        //let cellIdentifier:String = "Cell"
       // let cell =
        
       // if let pfObject = object {
          //  celltext = pfObject["Name"] as? String
          //  print(cell?.menuPrice?.text)
       // }
       // return cell;
    }
}
