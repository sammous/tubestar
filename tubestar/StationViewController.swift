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
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color_text
        let tblViewFooter = UIView(frame: CGRectZero)
        
        
        let buttonSetting: UIButton = UIButton(type: UIButtonType.Custom)
        buttonSetting.frame = CGRectMake(0, 0, 40, 40)
        buttonSetting.setImage(UIImage(named:"Setting.png"), forState: UIControlState.Normal)
        buttonSetting.addTarget(self, action: "rightNavItemClick:", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonSetting: UIBarButtonItem = UIBarButtonItem(customView: buttonSetting)
        
        self.navigationItem.setRightBarButtonItem(rightBarButtonSetting, animated: false)
        
        stationTableView.tableFooterView = tblViewFooter
        stationTableView.backgroundColor = UIColor.clearColor()
        

        
        let lineID = String(Array(line.characters)[0])
        
        var station = tfl.stationsOnLine[lineID]
        
        self.searchBar.keyboardAppearance = UIKeyboardAppearance.Dark
        
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

        let lineID = String(Array(line.characters)[0])
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredStations.count
        } else {
            return tfl.stationsOnLine[lineID]!.count
        }
    }
    
    
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: textCellIdentifier)
        let font = UIFont(name: "Aller", size: 18)

        let lineID = String(Array(line.characters)[0])
        
        var stations = [String]()
        
        if tableView == self.searchDisplayController?.searchResultsTableView{
            stations = self.filteredStations
            cell.textLabel!.text = stations[indexPath.row]
        } else {
            stations = tfl.stationsOnLine[lineID]!
            cell.textLabel!.text = tfl.stations[stations[indexPath.row]]

        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        cell.textLabel?.font = font
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let destination = stationTableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text!
        let message = "Do you want to go to " + destination! + " ?"
        
        let alert = UIAlertController(title: "Destination", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            self.destinationSelected = destination!
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let destinationViewController = storyboard.instantiateViewControllerWithIdentifier("destinationViewController") as! DestinationViewController
            print(self.destinationSelected)
            destinationViewController.stop = self.destinationSelected
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        //Solve speed issue of alertview
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func sendData(destination: String){
        print(destinationSelected)
        
        let localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "alertAction"
        localNotification.alertBody = "alert body"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        
        let tflObject = Tfl()
        let lineID = String(Array(line.characters)[0])
        
        let stations = tflObject.get_stops_from_line(lineID)
//        var stations: [String] = []
//        for i in 0...station_id!.count{
//            stations.append(tflObject.stations[station_id![i]]!)
//        }
        
        self.filteredStations = stations.filter({( stations: String) -> Bool in
            let stringMatch = stations.rangeOfString(searchText)
            return (stringMatch != nil)
        })
        
        stationTableView.reloadData()
        
    }
    
    func searchDisplayController(controller: UISearchController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
//    func searchDisplayController(controller: UISearchController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
//        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!)
//        return true
//    }
    
    
    func rightNavItemClick(sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let settingViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("settingViewController") 
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }

    
}