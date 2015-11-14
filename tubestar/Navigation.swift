//
//  Navigation.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 22/09/2015.
//  Copyright © 2015 Myintranet. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class Navigation: NSObject, CLLocationManagerDelegate, UIApplicationDelegate {
    
    let locationManager = CLLocationManager()
    var seenError : Bool = false
    var locationStatus : NSString = "Not Started"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        switch status {
        case .NotDetermined:
            locationManager.startUpdatingLocation()
            print(".NotDetermined")
            break
            
        case .Authorized:
            locationManager.startUpdatingLocation()
            print(".Authorized")
            break
            
        case .Denied:
            print(".Denied")
            break
            
        default:
            print("Unhandled authorization status")
            break
            
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last as CLLocation!
        
        print("didUpdateLocations:  \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
        print("error")
    }
}