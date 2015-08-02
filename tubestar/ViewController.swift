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

private let DeviceList = [
    /* iPod 5 */          "iPod5,1": "iPod Touch 5",
    /* iPhone 4 */        "iPhone3,1":  "iPhone 4", "iPhone3,2": "iPhone 4", "iPhone3,3": "iPhone 4",
    /* iPhone 4S */       "iPhone4,1": "iPhone 4S",
    /* iPhone 5 */        "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5",
    /* iPhone 5C */       "iPhone5,3": "iPhone 5C", "iPhone5,4": "iPhone 5C",
    /* iPhone 5S */       "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S",
    /* iPhone 6 */        "iPhone7,2": "iPhone 6",
    /* iPhone 6 Plus */   "iPhone7,1": "iPhone 6 Plus",
    /* iPad 2 */          "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
    /* iPad 3 */          "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3",
    /* iPad 4 */          "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
    /* iPad Air */        "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
    /* iPad Air 2 */      "iPad5,1": "iPad Air 2", "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
    /* iPad Mini */       "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini",
    /* iPad Mini 2 */     "iPad4,4": "iPad Mini", "iPad4,5": "iPad Mini", "iPad4,6": "iPad Mini",
    /* iPad Mini 3 */     "iPad4,7": "iPad Mini", "iPad4,8": "iPad Mini", "iPad4,9": "iPad Mini",
    /* Simulator */       "x86_64": "Simulator", "i386": "Simulator"
]

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        let mirror = reflect(machine)                // Swift 1.2
        // let mirror = Mirror(reflecting: machine)  // Swift 2.0
        var identifier = ""
        
        // Swift 1.2 - if you use Swift 2.0 comment this loop out.
        for i in 0..<mirror.count {
            if let value = mirror[i].1.value as? Int8 where value != 0 {
                identifier.append(UnicodeScalar(UInt8(value)))
            }
        }
        
        // Swift 2.0 and later - if you use Swift 2.0 uncomment his loop
        // for child in mirror.children where child.value as? Int8 != 0 {
        //     identifier.append(UnicodeScalar(UInt8(child.value as! Int8)))
        // }
        
        return DeviceList[identifier] ?? identifier
    }
    
}

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var items: [String] = []
    var wifis = [NSManagedObject]()
    
    var ssidScanned=""
    var bssidScanned=""
    
    @IBOutlet weak var outputTable: UITableView!
    
    let textCellIdentifier = "cell"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        populateTable()
    }

    
    func populateTable() {
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueID") {
            var svc = segue.destinationViewController as! PickerviewViewController;
            
            svc.ssid = ssidScanned
            svc.bssid = bssidScanned
            
            println("avant transition :" + ssidScanned)
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wifis.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let wifi = wifis[indexPath.row]
        
        let ssid_label = wifi.valueForKey("ssid")!.substringToIndex(5) as String
        let bssid_label = wifi.valueForKey("bssid")!.substringFromIndex(9) as String
        var text = "T:";
        text += String(format:"%.1f", wifi.valueForKey("timespan") as! Double)
        
        
        text += " SSID: "
        text +=  ssid_label
        text += " BSSID: "
        text += bssid_label
        
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
    
                    saveWifi(currentSSID, bssid: currentBSSID)
                    
                    
                    self.ssidScanned = "test"
                    bssidScanned = "test"
                    println("getssid triggerred" + ssidScanned)
                    
                    println(currentSSID + " with BSSID=" + currentBSSID)
                    println("===================")

                }
            }
            
        }
        
        return currentSSID
        
    }
    
    @IBAction func scanButton(sender: UIButton) {
//        self.getSSID()
        println(items)
        self.outputTable.reloadData()
    }
    
    func autoScan() {
        self.getSSID()
        println(items)
        if(!(getLastScanned()["timestamp"]! as! NSObject==0)) {
//            self.outputTable.reloadData()
        }
    }
    
    @IBAction func sendButton(sender: UIButton){
        sendWifis()
    }

    
    func sendWifis() {
        var object = PFObject(className: "locations")
        
        var temp_wifi_ssid_array:[String] = []
        var temp_wifi_bssid_array:[String] = []
        var temp_wifi_timestamp_array:[Double] = []
        var temp_wifi_timespan_array:[Float] = []
        for wifi in wifis {
            if( wifi.valueForKey("submitted") !== true) {
                temp_wifi_ssid_array.append((wifi.valueForKey("ssid") as? String)!)
                temp_wifi_bssid_array.append((wifi.valueForKey("bssid") as? String)!)
                temp_wifi_timestamp_array.append((wifi.valueForKey("timestamp")) as! Double)
                temp_wifi_timespan_array.append((wifi.valueForKey("timespan") as? Float)!)
                wifi.setValue(true, forKey: "submitted")
            }
        }
        

        object.addObject(UIDevice.currentDevice().identifierForVendor.UUIDString, forKey: "UDID")
        object.addObject((temp_wifi_ssid_array), forKey: "ssid")
        object.addObject((temp_wifi_bssid_array), forKey: "bssid")
        object.addObject((temp_wifi_timestamp_array), forKey: "timestamp")
        object.addObject((temp_wifi_timespan_array), forKey: "timespan")
        
        temp_wifi_ssid_array.removeAll(keepCapacity: false)
        temp_wifi_bssid_array.removeAll(keepCapacity: false)
        temp_wifi_timestamp_array.removeAll(keepCapacity: false)
        temp_wifi_timespan_array.removeAll(keepCapacity: false)
        
        object.saveEventually()
        
        var alert = UIAlertController(title: "Thank you", message: "Your contribution is appreciated ! Thank you !", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
            wifi.setValue(NSDate().timeIntervalSince1970, forKey: "timestamp")
            wifi.setValue(0, forKey: "timespan")
            wifi.setValue(false, forKey: "submitted")
            println(ssid + "has been added in db")
            //4
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
            //5
            wifis.append(wifi)
        } else {
            var lastScanned = getLastScanned()
            if(lastScanned["bssid"] as! String == bssid) {
                println("same bssid as last check")
                var result = fetchedResults?.last
                var newTimespan = NSDate().timeIntervalSinceDate(NSDate(timeIntervalSince1970: result?.valueForKey("timestamp") as! NSTimeInterval  ))
                result!.setValue(newTimespan, forKey: "timespan")
                result!.setValue(false, forKey: "submitted")
                println(newTimespan)
                var saveError : NSError? = nil
                if !managedContext.save(&saveError) {
                    println("Could not update record")
                } else {
    //                wifis.last = result
                    populateTable()
//                    ViewController().outputTable.reloadData()
                }
            }
        }
        
//        dispatch_after(5,
//            dispatch_get_main_queue()){
//                self.scanWifis()
//        };
    }
    
    
    
    
    func getLastScanned() -> [String:AnyObject] {
        var last = wifis.last
        var result:[String:AnyObject]
        if((last) != nil) {
            result = [
                "timestamp": last?.valueForKey("timestamp") as! Double,
                "timespan":last?.valueForKey("timespan") as! Double,
                "bssid":last?.valueForKey("bssid")! as! String
            ]
        } else {
            result = [
                "timestamp": 0 as Double,
                "timespan": 0 as Double,
                "bssid":"00:aa:00:aa:00:aa" as String
            ]
            
        }
        return result;
    }

}


