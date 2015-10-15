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
    var isValidAddress:Bool = false
    
    @IBOutlet weak var mapSearch: UISearchBar!

    @IBOutlet weak var mapView: MKMapView!
    @IBAction func goButton(sender: UIButton) {
    }
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get user's starting location
        self.mapView.mapType = MKMapType.Standard
        self.mapView.showsUserLocation = true
        self.mapView.removeAnnotations(self.mapView.annotations)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let location = self.locationManager.location
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
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = mapSearch.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

