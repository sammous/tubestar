//
//  StationViewController.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 02/08/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import Foundation
import UIKit


class StationViewContoller: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate{
    
    var line:String = ""
    
    let tfl = Tfl()
    
    let textCellIdentifier = "MyCell"
    
    var destinationSelected:String = ""
    
    var filteredStations = [String]()
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var stationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = line
        self.navigationItem.backBarButtonItem?.title = "Tubelines"
        stationTableView.delegate = self
        stationTableView.dataSource = self
        
        let color_text =  UIColor(red: 28 / 255, green: 186 / 255, blue: 156 / 255, alpha: 1.0)
        let color_background = UIColor(red: 45.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        self.searchBar.tintColor = color_text
//        searchBar.backgroundColor = UIColor.whiteColor()
        var textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color_text
        var tblViewFooter = UIView(frame: CGRectZero)
        
        
        let buttonSetting: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonSetting.frame = CGRectMake(0, 0, 40, 40)
        buttonSetting.setImage(UIImage(named:"Setting.png"), forState: UIControlState.Normal)
        buttonSetting.addTarget(self, action: "rightNavItemClick:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonSetting: UIBarButtonItem = UIBarButtonItem(customView: buttonSetting)
        
        self.navigationItem.setRightBarButtonItem(rightBarButtonSetting, animated: false)
        
        stationTableView.tableFooterView = tblViewFooter
        stationTableView.backgroundColor = UIColor.clearColor()
        

        
        var lineID = String(Array(line)[0])
        
        var station = tfl.stationsOnLine[lineID]
        
        
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
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredStations.count
        } else {
            return tfl.stationsOnLine[lineID]!.count
        }
    }
    
    
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: textCellIdentifier)
        let font = UIFont(name: "Aller", size: 18)

        var lineID = String(Array(line)[0])

        let station = tfl.stationsOnLine[lineID]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        cell.textLabel!.text = tfl.stations[station![indexPath.row]]
        cell.textLabel?.font = font
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let destination = stationTableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text!
        let message = "Do you want to go to " + destination! + " ?"
        
        var alert = UIAlertController(title: "Destination", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.destinationSelected = destination!
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let settingViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("destinationViewController") as! UIViewController
            println(self.destinationSelected)
            self.navigationController?.pushViewController(settingViewController, animated: true)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        //Solve speed issue of alertview
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func sendData(destination: String){
        println(destinationSelected)
        
        var localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "alertAction"
        localNotification.alertBody = "alert body"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        
        var lineID = String(Array(line)[0])
        
        var station = tfl.stationsOnLine[lineID]
        println(station)
        
        filteredStations = station!.filter({( station: String) -> Bool in
            let stringMatch = station.rangeOfString(searchText)
            return (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    
    func rightNavItemClick(sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let settingViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("settingViewController") as! UIViewController
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
    

    
}