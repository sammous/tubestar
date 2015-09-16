
//
//  DestinationViewController.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 16/09/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import Foundation
import UIKit


class DestinationViewController: UIViewController{
    
    var line: String = ""
    
    @IBOutlet weak var lineTitle: UILabel!
    @IBOutlet weak var changeDestination: UIButton!
    
    override func viewDidLoad() {
        
        let buttonSetting: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonSetting.frame = CGRectMake(0, 0, 40, 40)
        buttonSetting.setImage(UIImage(named:"Setting.png"), forState: UIControlState.Normal)
        buttonSetting.addTarget(self, action: "rightNavItemClick:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonSetting: UIBarButtonItem = UIBarButtonItem(customView: buttonSetting)
        
        self.navigationItem.setRightBarButtonItem(rightBarButtonSetting, animated: false)
        
        self.navigationItem.title = "Destination"
        
        var stationVC = StationViewContoller()
        let destination = stationVC.destinationSelected
        println(destination)
//        let font = UIFont(name: "Aller", size: 18.0)
//        lineTitle.numberOfLines = 0
//        lineTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        lineTitle.font = font
//        lineTitle.adjustsFontSizeToFitWidth = true
//        lineTitle.text = stationVC.destinationSelected
//        
//        lineTitle.sizeToFit()
        
        self.lineTitle.text = destination
        self.changeDestination.addTarget(self, action: "changeDestinationPressed:", forControlEvents: .TouchUpInside)
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }


    func changeDestinationPressed(sender: UIButton!) {
        
        
        var alert = UIAlertController(title: "Destination", message: "Are you sure you want to change destination ?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            println("change destination")
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        })

    }
    
    func rightNavItemClick(sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let settingViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("settingViewController") as! UIViewController
        self.navigationController?.pushViewController(settingViewController, animated: true)
        println("settings clicked")
    }
    
}