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
    
    var line:String?
    
    let tfl = Tfl()
    
    let textCellIdentifier = "MyCell"
    
    
    @IBOutlet weak var stationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = line!
        
        stationTableView.delegate = self
        stationTableView.dataSource = self
        
        
        var tblViewFooter = UIView(frame: CGRectZero)
        
        stationTableView.tableFooterView = tblViewFooter
        stationTableView.backgroundColor = UIColor.clearColor()
        

        
        var lineID = String(Array(line!)[0])
        
        let station = tfl.stationsOnLine[lineID]
        
        print(station)
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {

        var lineID = String(Array(line!)[0])
        
        return tfl.stationsOnLine[lineID]!.count
    }
    
    
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: textCellIdentifier)
        
        var lineID = String(Array(line!)[0])

        let station = tfl.stationsOnLine[lineID]
        
        cell.textLabel!.text = tfl.stations[station![indexPath.row]]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}