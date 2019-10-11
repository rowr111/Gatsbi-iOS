//
//  AppDelegate.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 6/7/15.
//  Copyright (c) 2015 Gatsbi. All rights reserved.
//

import UIKit
import Contacts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var contactStore = CNContactStore()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //Parse.setApplicationId("As1EaEcN4TEh5BmrnVnehMPcmNrqkcOSdSXbA9vP", clientKey:"47ZLllneeOM6V8YJVKhyRgsPxNilOsVTRAhfgeQr")
        ///*
        Parse.setLogLevel(.Info);
        
        let config = ParseClientConfiguration(block: {
            (ParseMutableClientConfiguration) -> Void in

            ParseMutableClientConfiguration.applicationId = "As1EaEcN4TEh5BmrnVnehMPcmNrqkcOSdSXbA9vP";
            ParseMutableClientConfiguration.clientKey = "47ZLllneeOM6V8YJVKhyRgsPxNilOsVTRAhfgeQr";
            ParseMutableClientConfiguration.server = "https://evening-beach-99377.herokuapp.com/parse";
        });
        
        Parse.initializeWithConfiguration(config);
//*/

        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle());
        

        if let currentUser = PFUser.currentUser()
        {
            print("user is logged in already!")
            self.window?.rootViewController = storyboard.instantiateViewControllerWithIdentifier("InviteHomeViewController") as? UIViewController

        }
        else
        {
            let setViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") 
            let rootViewController = self.window!.rootViewController
            rootViewController?.presentViewController(setViewController, animated: false, completion: nil)
        
        }
        
        
        return true
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func requestForContactsAccess(completionHandler: (accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
        case .Authorized:
            completionHandler(accessGranted: true)
            
        case .Denied, .NotDetermined:
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(accessGranted: access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.Denied {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage("Error", message: message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(accessGranted: false)
        }
    }
    
    func showMessage(title:String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
        let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        
        presentedViewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

}


