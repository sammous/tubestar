
//
//  Database.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 02/09/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import Foundation


class Database {
    
    func dataOfJson(url: String) -> NSArray {
        
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        return ((try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSArray)


//        let jsonURL = NSBundle.mainBundle().URLForResource("http://tubestar.uk/api/locations/lines?udid=Y00YVfbIvMJ4uyqiRSUi0svEVcvZUHbjvfMfKB8Z", withExtension: "json")!
//        println(jsonURL)
//        
//        let jsonData = NSData(contentsOfURL: jsonURL)
//        println(jsonData)
//        
//        var error: NSError?
//        let jsonArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: &error) as! NSArray
//    
//        println(jsonArray)
        
    }
    
//    func loadPosts(posts:NSArray){
//        for post in posts {
//            var data = post["data"]! as! NSDictionary
//            var id = (post["id"]! as! String).toInt()
//            var name = post["name"]as! String
//            var tlfid = post["tflid"]as! String
//            
//            var postObj = Post(id: id, name: name, tflid:tfid)
//        }
//    }
//    
}