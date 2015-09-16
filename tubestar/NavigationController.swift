//
//  NavigationController.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 16/09/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import Foundation
import UIKit


class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let buttonSetting: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonSetting.frame = CGRectMake(0, 0, 40, 40)
        buttonSetting.setImage(UIImage(named:"Setting.png"), forState: UIControlState.Normal)
        buttonSetting.addTarget(self, action: "rightNavItemClick:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonSetting: UIBarButtonItem = UIBarButtonItem(customView: buttonSetting)

        
        self.navigationItem.setRightBarButtonItem(rightBarButtonSetting, animated: false)
        
        self.navigationItem.title = "test"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func rightNavItemClicl(sender: UIButton){
        
        println("settings clicked")
    }
    
    
    
}