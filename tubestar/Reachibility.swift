//
//  Reachibility.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 27/07/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import Foundation
import UIKit


class AppDelegate: UIResponder, UIApplicationDelegate
{
    private var reachability:Reachability!;
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"checkForReachability:", name: kReachabilityChangedNotification, object: nil);
        
        self.reachability = Reachability.reachabilityForInternetConnection();
        self.reachability.startNotifier();
    }
    
    func checkForReachability(notification:NSNotification)
    {
        // Remove the next two lines of code. You cannot instantiate the object
        // you want to receive notifications from inside of the notification
        // handler that is meant for the notifications it emits.
        
        //var networkReachability = Reachability.reachabilityForInternetConnection()
        //networkReachability.startNotifier()
        
        let networkReachability = notification.object as Reachability;
        var remoteHostStatus = networkReachability.currentReachabilityStatus()
        
        if (remoteHostStatus.value == NotReachable.value)
        {
            println("Not Reachable")
        }
        else if (remoteHostStatus.value == ReachableViaWiFi.value)
        {
            println("Reachable via Wifi")
        }
        else
        {
            println("Reachable")
        }
    }
}