//
//  ViewController.swift
//  tubestar
//
//  Created by Vladyslav Piskunov on 25/07/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import UIKit

import SystemConfiguration.CaptiveNetwork

import CoreData

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var items: [String] = []
    var wifis = [NSManagedObject]()
    @IBOutlet weak var outputTable: UITableView!
    
    let textCellIdentifier = "cell"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Wifi_data")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            wifis = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.outputTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        outputTable.delegate = self
        outputTable.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wifis.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let wifi = wifis[indexPath.row]
        
        let ssid_label = wifi.valueForKey("ssid") as? String
        let bssid_label = wifi.valueForKey("bssid") as? String
        
        
        var text = "SSID: " + ssid_label! + " BSSID: " + bssid_label!
        
        cell.textLabel?.text=text
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
  
    
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
    
                    saveWifi(currentSSID,bssid: currentBSSID)
                        
                    println(currentSSID + " with BSSID=" + currentBSSID)
                    println("===================")

                }
            }
            
        }
        
        return currentSSID
        
    }    
    
    @IBAction func scanButton(sender: UIButton) {
        self.getSSID()
        println(items)
        self.outputTable.reloadData()
    }
    
    
    func saveWifi(ssid: String, bssid: String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Wifi_data",
            inManagedObjectContext:
            managedContext)
        

        
        let resultPredicate = NSPredicate(format: "bssid = %@", bssid)

        let fetchRequest = NSFetchRequest(entityName:"Wifi_data")
        
        var error: NSError?

        fetchRequest.predicate = resultPredicate
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if fetchedResults?.count == 0 {
            let wifi = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:managedContext)

            wifi.setValue(ssid, forKey: "ssid")
            wifi.setValue(bssid, forKey: "bssid")
            println(ssid + "has been added in db")
            //4
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
            //5
            wifis.append(wifi)
        } else {
            println("bssid already in db")
        }
    }

}


