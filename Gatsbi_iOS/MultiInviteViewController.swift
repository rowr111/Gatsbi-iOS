//
//  MultiInviteViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 1/3/16.
//  Copyright © 2016 Gatsbi. All rights reserved.
//

import Foundation
import UIKit

class MultiInviteViewController: UIViewController {
    
    var myInviteEvents:[UserInviteEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Invite count: \(myInviteEvents.count)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

