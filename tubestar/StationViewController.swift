//
//  StationViewController.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 02/08/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import Foundation
import UIKit


class StationViewContoller: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var line:String = ""
    
    let tfl = Tfl()
    
    let textCellIdentifier = "MyCell"
    
    var destinationSelected:String = ""
    
    @IBOutlet weak var stationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = line
        
        stationTableView.delegate = self
        stationTableView.dataSource = self
        
        
        var tblViewFooter = UIView(frame: CGRectZero)
        
        stationTableView.tableFooterView = tblViewFooter
        stationTableView.backgroundColor = UIColor.clearColor()
        

        
        var lineID = String(Array(line)[0])
        
        let station = tfl.stationsOnLine[lineID]
        
        
        /* Handling long press
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        self.view.addGestureRecognizer(longPressRecognizer)
        */

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {

        var lineID = String(Array(line)[0])
        
        return tfl.stationsOnLine[lineID]!.count
    }
    
    
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: textCellIdentifier)
        
        var lineID = String(Array(line)[0])

        let station = tfl.stationsOnLine[lineID]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        cell.textLabel!.text = tfl.stations[station![indexPath.row]]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let destination = stationTableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text!
        let message = "Do you want to go to " + destination! + " ?"
        
        var alert = UIAlertController(title: "Destination", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.destinationSelected = destination!
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        //Solve speed issue of alertview
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    
    /* handling long press
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = longPressGestureRecognizer.locationInView(self.view)
            if let indexPath = stationTableView.indexPathForRowAtPoint(touchPoint) {
                var alert = UIAlertController(title: "Alert", message: stationTableView.cellForRowAtIndexPath(indexPath)!.textLabel!.text, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    */
    
    func sendData(destination: String){
        println(destinationSelected)
        
        var localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "alertAction"
        localNotification.alertBody = "alert body"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    
}