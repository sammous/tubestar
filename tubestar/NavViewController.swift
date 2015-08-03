//
//  NavViewController.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 02/08/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import Foundation
import UIKit

class NavViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
        
    @IBOutlet weak var tableViewLines: UITableView!
    
    let textCellIdentifier = "MyCell"

    let tfl = Tfl()
    
    let selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Navigation"
        
        tableViewLines.delegate = self
        tableViewLines.dataSource = self
        
        
        var tblViewFooter = UIView(frame: CGRectZero)
        
        tableViewLines.tableFooterView = tblViewFooter
        tableViewLines.backgroundColor = UIColor.clearColor()
        
    
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

    
    
    
    func getStationsOnLine(lineName: String) -> [String:String] {
        let stations:[String] = tfl.stationsOnLine[lineName]!
        var results = [String:String]()
        
        for station in stations {
            results[station] = self.tfl.stations[station]! as String
        }
        return results
        
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return tfl.lines.count
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: textCellIdentifier)
        
        let linesName = [Array](tfl.lines.values)
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = linesName[indexPath.row][0] as? String

        //cell.backgroundColor = linesName[indexPath.row][1] as? UIColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("getStation", sender: indexPath);

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            
            if segue.identifier == "getStation" {
                let stationViewController = segue.destinationViewController
                    as! StationViewContoller
                
                let myIndexPath = tableViewLines.indexPathForSelectedRow()
                let row = (sender as! NSIndexPath).row
                let linesName = [Array](tfl.lines.values)
                let lineselected = linesName[row]
                println(linesName)
                
            }
    }
    
}