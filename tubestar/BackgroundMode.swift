//
//  BackgroundMode.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 12/08/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import UIKit
import AVFoundation


class BackgroundMode {
    

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate


    var enabled:Bool = false
    var audioPlayer:AVAudioPlayer!
    
    func pluginInitialize(){
        
        switch UIApplication.sharedApplication().applicationState {
        case .Active:
            self.enabled = false
            print("app active")
        case .Background:
            self.enabled = true
            print("app in background")
        case .Inactive:
            print("app inactive")
            break
        }
    
    }

    func observeLifeCycle(){

        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "didEnterBackground:",
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil)
    
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "didBecameActive:",
            name: UIApplicationWillEnterForegroundNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "didBecameActive:",
            name: AVAudioSessionInterruptionNotification,
            object: nil)
        
    }
    
    func enable(){
        self.enabled = true
    }
    
    func disable(){
        self.enabled = false
    }
    
    func keepAwake(){
        if (self.enabled){
            self.audioPlayer.play()
        }
    }
}

