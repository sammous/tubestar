//
//  PostService.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 12/09/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import Foundation
import UIKit

class PostService {
    
    var settings:Settings!
    
    init(){
        self.settings = Settings()
    }
    
    func getPosts(callback:(NSDictionary)->()) {
        println("get posts")
        request(settings.viewPosts,callback: callback)
    }
    
    func request(url:String,callback:(NSDictionary)->()) {
        var nsURL = NSURL(string: url)
        println(callback)
        let task = NSURLSession.sharedSession().dataTaskWithURL(nsURL!) {
            (data,response,error) in
            var error:NSError?
            var response = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
            callback(response)
        }
        task.resume()
    }
}