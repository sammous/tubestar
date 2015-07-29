//
//  Reachability.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 27/07/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import Foundation
public class Reachability {
    
 /*   private var reachability:Reachability!;

    
    class func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
    
    
    func checkForReachability(notification:NSNotification)
    {
        // Remove the next two lines of code. You cannot instantiate the object
        // you want to receive notifications from inside of the notification
        // handler that is meant for the notifications it emits.
        
        //var networkReachability = Reachability.reachabilityForInternetConnection()
        //networkReachability.startNotifier()
        
        let networkReachability = notification.object as! Reachability;
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
    }*/
}