
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
    var stop:String = ""
    @IBOutlet weak var lineTitle: UILabel!
    @IBOutlet weak var changeDestination: UIButton!

    
    override func viewDidLoad() {
        
        let buttonSetting: UIButton = UIButton(type: UIButtonType.Custom)
        buttonSetting.frame = CGRectMake(0, 0, 40, 40)
        buttonSetting.setImage(UIImage(named:"Setting.png"), forState: UIControlState.Normal)
        buttonSetting.addTarget(self, action: "rightNavItemClick:", forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonSetting: UIBarButtonItem = UIBarButtonItem(customView: buttonSetting)
        
        self.navigationItem.setRightBarButtonItem(rightBarButtonSetting, animated: false)
        
        self.navigationItem.title = "Destination"
        

//        let font = UIFont(name: "Aller", size: 18.0)
//        lineTitle.numberOfLines = 0
//        lineTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        lineTitle.font = font
//        lineTitle.adjustsFontSizeToFitWidth = true
//        lineTitle.text = stationVC.destinationSelected
//        
//        lineTitle.sizeToFit()
        
        self.lineTitle.text = stop
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
        
        
        let alert = UIAlertController(title: "Destination", message: "Are you sure you want to change destination ?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            print("change destination")
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        })

    }
    
    func rightNavItemClick(sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let settingViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("settingViewController") 
        self.navigationController?.pushViewController(settingViewController, animated: true)
        print("settings clicked")
    }
    
    

    
}