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
    
    var labelSelected:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let font = UIFont(name: "Aller", size: 18)
        let color =  UIColor(red: 28 / 255, green: 186 / 255, blue: 156 / 255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : font!, NSForegroundColorAttributeName : color]
        self.navigationItem.title = "Tubelines"

        let backButton = UIBarButtonItem(title: "Tubelines", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Aller", size: 16)!], forState: UIControlState.Normal)
        self.navigationItem.backBarButtonItem = backButton
        
        let buttonSetting: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonSetting.frame = CGRectMake(0, 0, 40, 40)
        buttonSetting.setImage(UIImage(named:"Setting.png"), forState: UIControlState.Normal)
        buttonSetting.addTarget(self, action: "rightNavItemClick:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonSetting: UIBarButtonItem = UIBarButtonItem(customView: buttonSetting)
        
        self.navigationItem.setRightBarButtonItem(rightBarButtonSetting, animated: false)
        
        tableViewLines.delegate = self
        tableViewLines.dataSource = self
        
        
        var tblViewFooter = UIView(frame: CGRectZero)
        
        tableViewLines.tableFooterView = tblViewFooter
        tableViewLines.backgroundColor = UIColor.clearColor()
        

    }
    
    override func viewWillAppear(animated: Bool) {
        
        if ( self.tableViewLines.indexPathForSelectedRow() != nil ){
            tableViewLines.deselectRowAtIndexPath(self.tableViewLines.indexPathForSelectedRow()!, animated: true)
        }
        
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
        let font = UIFont(name: "Aller", size: 18)
        let linesName = [Array](tfl.lines.values)
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        cell.textLabel?.text = linesName[indexPath.row][0] as? String
        cell.textLabel?.font = font

        //cell.backgroundColor = linesName[indexPath.row][1] as? UIColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableViewLines.cellForRowAtIndexPath(indexPath)
        labelSelected = cell!.textLabel!.text!
        self.performSegueWithIdentifier("getStation", sender: indexPath);
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
                let stationVC = segue.destinationViewController
                    as! StationViewContoller
            
                stationVC.line = labelSelected
                println(labelSelected)
                

    }
    
    func rightNavItemClick(sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let settingViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("settingViewController") as! UIViewController
        self.navigationController?.pushViewController(settingViewController, animated: true)
        println("settings clicked")
    }
    
}