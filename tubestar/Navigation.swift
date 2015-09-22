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
    
    var locationManager:CLLocationManager = CLLocationManager()
    var seenError : Bool = false
    var locationStatus : NSString = "Not Started"
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        switch status {
        case .NotDetermined:
            print(".NotDetermined")
            break
            
        case .Authorized:
            self.locationManager.startUpdatingLocation()
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