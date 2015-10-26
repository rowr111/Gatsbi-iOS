//
//  HostAddressViewController.swift
//  Gatsbi_iOS
//
//  Created by Jeanie Conner on 10/14/15.
//  Copyright © 2015 Gatsbi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HostAddressViewController : UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    var myInvite:Invite?
    var myAddress:String?
    var myAddressArray:[String] = []
    var isValidAddress:Bool = false
    
    @IBOutlet weak var mapSearch: UISearchBar!

    @IBOutlet weak var mapView: MKMapView!
    @IBAction func goButton(sender: UIButton) {
        let alertController = UIAlertController(title: "Confirm Host Address", message: myAddressArray.joinWithSeparator("\n"), preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            print("you have pressed OK button");
            self.myAddress = self.myAddressArray.joinWithSeparator(" ")
            self.performSegueWithIdentifier("timeSegue", sender: self)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
    //some mappy variables
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get user's starting location
        self.mapView.mapType = MKMapType.Standard
        self.mapView.showsUserLocation = true
        self.mapView.removeAnnotations(self.mapView.annotations)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .Authorized:
            print("authorized")
        case .AuthorizedWhenInUse:
            print("authorized when in use")
        case .Denied:
            print("denied")
        case .NotDetermined:
            print("not determined")
        case .Restricted:
            print("restricted")
        }
        locationManager.startUpdatingLocation()
        
        let location = locationManager.location
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        
        //set searchbar's delegate 
        mapSearch.delegate = self

    }
    
    func searchBarSearchButtonClicked(mapSearch: UISearchBar)
    {
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = mapSearch.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Address Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            self.myAddressArray = (localSearchResponse?.mapItems[0].placemark.addressDictionary?["FormattedAddressLines"])! as! [String]
            self.myAddress = self.myAddressArray.joinWithSeparator(" ")
            
            
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = self.myAddress
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            //self.mapView.showAnnotations(self.pinAnnotationView.annotation! as! [MKAnnotation], animated: true)
            
            print(localSearchResponse?.mapItems[0].placemark.addressDictionary?["FormattedAddressLines"])
            //print(localSearchResponse?.mapItems[0].placemark.subThoroughfare)

            
            //we found an address, hooray.
            self.isValidAddress = true
        
            //this is if we want to get a nicely formatted address
            //let geoCoder = CLGeocoder()
            //let location = CLLocation(latitude: self.pointAnnotation.coordinate.latitude, longitude: //self.pointAnnotation.coordinate.longitude)
            
            //geoCoder.reverseGeocodeLocation(location) {
              //  (placemarks, error) -> Void in
              //  if let placemarks = placemarks as [CLPlacemark]! where placemarks.count > 0 {
              //      let placemark = placemarks[0]
               //     self.myAddress = placemark.name! + " " + placemark.locality! + ", " + placemark.administrativeArea! + " " + placemark.postalCode!
               //     print(placemark.addressDictionary)
                    //self.mapSearch.text = self.myAddress!
               // }
            //}
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case "timeSegue":
                print("let's do the time warp again")
                if let timeController = segue.destinationViewController as? InviteTimeViewController{
                    //pass along the invite, including the date and selected menu, hooray!
                    timeController.myInvite = myInvite!
                }
         
            default: break
                   }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

