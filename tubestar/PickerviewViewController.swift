//
//  PickerviewViewController.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 30/07/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//



import UIKit
import Foundation


protocol PickerviewVCDelegate{
    func didFinishpickerVC(controller:PickerviewViewController)
}


class PickerviewViewController: UIViewController {

    var delegate:PickerviewVCDelegate!=nil
    
    var ssid=""
    var bssid=""

    @IBOutlet weak var ssidLabel: UILabel!
    @IBOutlet weak var bssidLabel: UILabel!

    @IBAction func backButton(sender: UIButton) {
        navigationController?.popViewControllerAnimated(false)
        delegate.didFinishpickerVC(self)
    }
    
    @IBOutlet weak var picker1: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var back = UIBarButtonItem(title: "< Back", style: .Plain, target: self, action: "barButtonItemClicked:")
        
        self.navigationItem.setLeftBarButtonItem(back, animated: true)
        self.navigationItem.title = "Select a location"
        
        updateLabel()
        println("---")
        println(ssid)
        println(bssid)
        println("---")


    }
    

    func barButtonItemClicked(sender: UIBarButtonItem){
        navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int
    {
        return 10
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!{
        return String(row + 1)
    }
    
    func updateLabel(){
        ssidLabel.text = ssid
        ssidLabel.sizeToFit()
        bssidLabel.text = bssid
        bssidLabel.sizeToFit()
    }

};