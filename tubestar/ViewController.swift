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

import AVFoundation

import Darwin

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
        //let mirror = reflect(machine)                // Swift 1.2
        let mirror = Mirror(reflecting: machine)  // Swift 2.0
        var identifier = ""
        
        // Swift 1.2 - if you use Swift 2.0 comment this loop out.
//        for i in 0..<mirror.count {
//            if let value = mirror[i].1.value as? Int8 where value != 0 {
//                identifier.append(UnicodeScalar(UInt8(value)))
//            }
//        }
        
        // Swift 2.0 and later - if you use Swift 2.0 uncomment his loop
         for child in mirror.children where child.value as? Int8 != 0 {
             identifier.append(UnicodeScalar(UInt8(child.value as! Int8)))
         }
        
        return DeviceList[identifier] ?? identifier
    }
    
}

class ViewController: UIViewController {
    var items: [String] = []
    var wifis = [NSManagedObject]()
    
    
    var player: AVQueuePlayer!
    
    var fact: [String] = []
    
    let textCellIdentifier = "cell"
    
    
    @IBOutlet weak var homeFact: UILabel!

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hasDisconnected = true
        
        
        
        print("devide id:\n")
        print(UIDevice.currentDevice().identifierForVendor!.UUIDString)

        
        let backButton = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Aller", size: 20)!], forState: UIControlState.Normal)
        self.navigationItem.backBarButtonItem = backButton
        
        let buttonSetting: UIButton = UIButton(type: UIButtonType.Custom)
        buttonSetting.frame = CGRectMake(0, 0, 40, 40)
        buttonSetting.setImage(UIImage(named:"Setting.png"), forState: UIControlState.Normal)
        buttonSetting.addTarget(self, action: "rightNavItemClick:", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonSetting: UIBarButtonItem = UIBarButtonItem(customView: buttonSetting)
        
        self.navigationItem.setRightBarButtonItem(rightBarButtonSetting, animated: false)

        let buttonMap: UIButton = UIButton(type: UIButtonType.Custom)
        buttonMap.frame = CGRectMake(0, 0, 40, 40)
        buttonMap.setImage(UIImage(named:"Map.png"), forState: UIControlState.Normal)
        buttonMap.addTarget(self, action: "leftNavItemClick:", forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarButtonSetting: UIBarButtonItem = UIBarButtonItem(customView: buttonMap)
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonSetting, animated: false)
        
        var error: NSError?
        var success: Bool
        do {
            try AVAudioSession.sharedInstance().setCategory(
                        AVAudioSessionCategoryPlayAndRecord,
                        withOptions: .MixWithOthers)
            success = true
        } catch let error1 as NSError {
            error = error1
            success = false
        }
        if !success {
            NSLog("Failed to set audio session category.  Error: \(error)")
        }
        
        let songNames = ["Mesmerize"]
        let songs = songNames.map {
            AVPlayerItem(URL: NSBundle.mainBundle().URLForResource($0, withExtension: "mp3")!)
        }
        
        player = AVQueuePlayer(items: songs)
        player.actionAtItemEnd = .Advance
        
        
        player.addObserver(self, forKeyPath: "currentItem", options: [.New, .Initial] , context: nil)


        
        player.addPeriodicTimeObserverForInterval(CMTimeMake(100,100), queue: dispatch_get_main_queue()) {
            [unowned self] time in
            let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
            if UIApplication.sharedApplication().applicationState == .Active {
                print(timeString)
            } else {
                self.autoScan()
                NSLog("Background time remaining = %.1f seconds", UIApplication.sharedApplication().backgroundTimeRemaining)
                print("Background: \(timeString)")
            }
        }
        
        player.play()
        player.volume = 0.0
        
        fact = ["The busiest Tube station is Oxford Circus, used by around 98 million passengers in 2014", "Compared to Paris, London sucks"]
        
        loadFact(homeFact,fact: fact)
                        
    }
   
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "currentItem", let player = object as? AVPlayer,
            currentItem = player.currentItem?.asset as? AVURLAsset {
                print(currentItem.URL.lastPathComponent ?? "Unknown")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }

    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "") {
            var svc = segue.destinationViewController as! PickerviewViewController;
            
            svc.ssid = ssidScanned
            svc.bssid = bssidScanned
            
            println("avant transition :" + ssidScanned)
            
        }
    }
    */
    
    func getSSID() -> String{
        
        var currentSSID = ""
        var currentBSSID = ""
        let array = ["50:a7:33:f:ca:58","3c:ce:73:f6:9e:1d","3c:ce:73:f6:9e:12","c8:f9:f9:2a:3e:ed","3c:ce:73:f8:3d:7d","3c:ce:73:f8:3d:72","c8:f9:f9:2a:3e:e2","3c:ce:73:6c:84:fc","3c:ce:73:6c:84:fc","3c:ce:73:6c:84:f3","c8:f9:f9:72:0b:b3","c8:f9:f9:72:0b:bc","3c:ce:73:6c:84:fc","3c:ce:73:6c:84:f3","c8:f9:f9:72:0b:b3","c8:f9:f9:72:0b:bc","3c:ce:73:f6:f3:1c","3c:ce:73:f6:f3:13","3c:ce:73:6c:84:fc","c8:f9:f9:72:0b:b3","c8:f9:f9:72:0b:bc","3c:ce:73:f6:f3:1c","3c:ce:73:f6:f3:1c","3c:ce:73:6c:84:fc","3c:ce:73:6c:84:f3","c8:f9:f9:72:0b:b3","c8:f9:f9:72:0b:bc","3c:ce:73:f6:f3:1c","3c:ce:73:f6:f3:13","50:a7:33:f:ca:58"]
// Swift 1.2
//        let interfaces = CNCopySupportedInterfaces()
//        
//        if interfaces != nil {
//            
//            let interfacesArray = interfaces.takeRetainedValue() as! [String]
//            
//            if interfacesArray.count > 0 {
//                
//                let interfaceName = interfacesArray[0] as String
//                
//                let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
//                
//                if unsafeInterfaceData != nil {
//                    
//                    let interfaceData = unsafeInterfaceData.takeRetainedValue() as Dictionary!
        
//Swift 2.0
        let interfaces = CNCopySupportedInterfaces()
        if interfaces != nil {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafePointer<Void> = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)")
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as NSDictionary
                    
                currentBSSID = interfaceData.valueForKey("BSSID")! as! String
                currentSSID = interfaceData.valueForKey("SSID")! as! String
            

                }
            }
        }
        
//                    let ssiddata = NSString(data:interfaceData[kCNNetworkInfoKeySSID]! as! NSData, encoding:NSUTF8StringEncoding) as! String
                    
                    //ssid data from hex
    
                    if array.contains(currentBSSID){
                        let localNotification:UILocalNotification = UILocalNotification()
                        localNotification.alertAction = "Arrived at station"
                        localNotification.alertBody = ""
                        localNotification.fireDate = nil
                        localNotification.soundName = UILocalNotificationDefaultSoundName
                        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                    }
                    
                    saveWifi(currentSSID, bssid: currentBSSID)
                    
                    
                    print(currentSSID + " with BSSID=" + currentBSSID)
                    print("===================")
//                    hasDisconnected = false
        
        print("just called getSSID(), after which hasDisconnected has a value of \(hasDisconnected)")
        
        return currentSSID
        
    }
    
    @IBAction func refreshData(sender: UIButton) {
//        self.getSSID()

        player.play()
        player.volume = 0.0

    
    }
    
    func loadFact(label: UILabel, fact:[String]){
        let diceRoll = Int(arc4random_uniform(UInt32(fact.count)))
        let font = UIFont(name: "Aller", size: 18.0)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.adjustsFontSizeToFitWidth = true
        label.text = fact[diceRoll]
        
        label.sizeToFit()

    }
    
    
    func rightNavItemClick(sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let settingViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("settingViewController") 
        self.navigationController?.pushViewController(settingViewController, animated: true)
        print("settings clicked")
    }
    
    func leftNavItemClick(sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let settingViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("mapViewController")
        self.navigationController?.pushViewController(settingViewController, animated: true)
        print("settings clicked")
    }
    
    
    func autoScan() {
        self.getSSID()
        print(items)
        if(!(getLastScanned()["timestamp"]! as! NSObject==0)) {
//            self.outputTable.reloadData()
        }
    }
    
    @IBAction func sendButton(sender: UIButton){
        sendWifis()
    }
    
    var hasDisconnected = false
    
    func sendWifis() {
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Wifi_data",
            inManagedObjectContext:
            managedContext)
        
        
        
        let resultPredicate = NSPredicate(format: "submitted = %@", false)
        
        let fetchRequest = NSFetchRequest(entityName:"Wifi_data")
        
        var error: NSError?
        
        fetchRequest.predicate = resultPredicate
        
        do {
        let fetchedResults =
        try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        
            if (fetchedResults?.count !== 0)  {
                if let results = fetchedResults {
                    print("found unsubmitted bssid's")
                    
                }
            }

        } catch {
            print(error)
        }
        
        
        let alert = UIAlertController(title: "Thank you", message: "Your contribution is appreciated ! Thank you !", preferredStyle: UIAlertControllerStyle.Alert)
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
        
        do {
        let fetchedResults =
        try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            var lastScanned = getLastScanned()
            if ((fetchedResults?.count == 0 && lastScanned["bssid"] as! String != bssid) || hasDisconnected == true)  {
                print("line 398 now will set hasDisconnected = false !!!!!!#!#!#!#!#!#!#")
                hasDisconnected = false
                let wifi = NSManagedObject(entity: entity!,
                    insertIntoManagedObjectContext:managedContext)
                
                wifi.setValue(ssid, forKey: "ssid")
                wifi.setValue(bssid, forKey: "bssid")
                wifi.setValue(NSDate().timeIntervalSince1970, forKey: "timestamp")
                wifi.setValue(0, forKey: "timespan")
                wifi.setValue(false, forKey: "submitted")
                print(ssid + "has been added in db")
                //4
                do {
                    try managedContext.save()
                } catch let error1 as NSError {
                    error = error1
                    print("Could not save \(error), \(error?.userInfo)")
                }
                //5
                wifis.append(wifi)
                
                //Notification
                let localNotification:UILocalNotification = UILocalNotification()
                localNotification.alertAction = "New wifi"
                localNotification.alertBody = "You just found a new wifi !"
                localNotification.fireDate = nil
                localNotification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                
            } else {
                print("same bssid as last check")
                let result = fetchedResults?.last
                let newTimespan = NSDate().timeIntervalSinceDate(NSDate(timeIntervalSince1970: result?.valueForKey("timestamp") as! NSTimeInterval  ))
                result!.setValue(newTimespan, forKey: "timespan")
                result!.setValue(false, forKey: "submitted")
                print(newTimespan)
                var saveError : NSError? = nil
                do {
                    try managedContext.save()
                    
                } catch let error as NSError {
                    saveError = error
                    print("Could not update record")
                }
            }
            
        } catch {
            print(error)
        }
    }
    
    
    
    
    func getLastScanned() -> [String:AnyObject] {
        let last = wifis.last
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
    
    
    func scrollToBottom(tableView: UITableView){
        
        let numberOfSections = tableView.numberOfSections
        let numberOfRows = tableView.numberOfRowsInSection(0)
        
        if numberOfRows > 0 {
            let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
        
    }

}


