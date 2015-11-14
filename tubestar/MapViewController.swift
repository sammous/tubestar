//
//  MapViewController.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 22/09/2015.
//  Copyright © 2015 Myintranet. All rights reserved.
//

import Foundation
import UIKit

class MapViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var map: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let font = UIFont(name: "Aller", size: 18)
        let color =  UIColor(red: 28 / 255, green: 186 / 255, blue: 156 / 255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : font!, NSForegroundColorAttributeName : color]
        
        let path = NSBundle.mainBundle().pathForResource("standard-tube-map", ofType: "pdf")
        
        let url = NSURL.fileURLWithPath(path!)
        
        self.map.delegate = self
        
        self.map.loadRequest(NSURLRequest(URL:url))
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.scrollView.zoomScale = 5.0
    }
}