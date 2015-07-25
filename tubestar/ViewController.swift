//
//  ViewController.swift
//  tubestar
//
//  Created by Vladyslav Piskunov on 25/07/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import UIKit

import SystemConfiguration.CaptiveNetwork

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var items: [String] = ["We", "Heart", "Swift"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.outputTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
  
    @IBOutlet weak var outputTable: UITableView!
    
    func getSSID() -> String{
        
        var currentSSID = ""
        var currentBSSID = ""
        
        let interfaces = CNCopySupportedInterfaces()
        
        if interfaces != nil {
            
            let interfacesArray = interfaces.takeRetainedValue() as! [String]
            
            if interfacesArray.count > 0 {
                
                let interfaceName = interfacesArray[0] as String
                
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                
                if unsafeInterfaceData != nil {
                    
                    let interfaceData = unsafeInterfaceData.takeRetainedValue() as Dictionary!
                    
                    currentSSID = interfaceData[kCNNetworkInfoKeySSID] as! String
                    currentBSSID = interfaceData[kCNNetworkInfoKeyBSSID] as! String
                    
//                    let ssiddata = NSString(data:interfaceData[kCNNetworkInfoKeySSID]! as! NSData, encoding:NSUTF8StringEncoding) as! String
                    
                    //ssid data from hex
//                    println(ssiddata)
                    println(currentSSID + " with BSSID=" + currentBSSID)
//                    println("")
//                    println(currentBSSID)
                    println("===================")
                }
            }
            
        }
        
        return currentSSID
        
    }
    
    
    @IBAction func scanButton(sender: UIButton) {
        self.getSSID()
    }


}


