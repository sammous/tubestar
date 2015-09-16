
//
//  ApiManager.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 12/09/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import Foundation
import CoreData

typealias ServiceResponse = (JSON, NSError?) -> Void

class ApiManager: NSObject {
    static let sharedInstance = ApiManager()
    
    let baseURL = "http://tubestar.uk/api/locations/lines?udid=Y00YVfbIvMJ4uyqiRSUi0svEVcvZUHbjvfMfKB8Z"

    func getData(onCompletion: (JSON) -> Void){
        makeHTTPGetRequest(baseURL, onCompletion: { json, err -> Void in
            onCompletion(json)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse){
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            let json:JSON = JSON(data: data)
            onCompletion(json, error)
            })
        task.resume()
    }
    
    //Save new Line
    func saveLine(id: Int, name: String, tflid: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        
        let fetchRequest = NSFetchRequest(entityName: "Line")
        fetchRequest.predicate = NSPredicate(format: "id = \(id)")

        
        var fetchRequestResults = managedContext.executeFetchRequest(fetchRequest, error: nil)
        
            if fetchRequestResults?.count == 0 {
                let entity = NSEntityDescription.entityForName("Line", inManagedObjectContext: managedContext)
                let station = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                station.setValue(id, forKey: "id")
                station.setValue(name, forKey: "name")
                station.setValue(tflid, forKey: "tflid")
                println("new line added successfully")
                
            } else {
                println("already in coredata")
            }

        
        var error: NSError?
        if !managedContext.save(&error){
            println("Could not save \(error), \(error?.userInfo)")
        }

    }
    
    //Save new Station
    func saveStation(id: Int, name: String, tflid: String, lat: Float, lon: Float, wifi: Int, lines: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        
        let fetchRequest = NSFetchRequest(entityName: "Station")
        fetchRequest.predicate = NSPredicate(format: "id = \(id)")
        
        
        var fetchRequestResults = managedContext.executeFetchRequest(fetchRequest, error: nil)
        
        if fetchRequestResults?.count == 0 {
            let entity = NSEntityDescription.entityForName("Station", inManagedObjectContext: managedContext)
            let station = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            station.setValue(id, forKey: "id")
            station.setValue(name, forKey: "name")
            station.setValue(tflid, forKey: "tflid")
            station.setValue(lat, forKey: "lat")
            station.setValue(lon, forKey: "lon")
            station.setValue(wifi, forKey: "wifi")
            station.setValue(lines, forKey: "lines")

            println("new station added successfully")
            
        } else {
            println("already in coredata")
        }
        
        
        var error: NSError?
        if !managedContext.save(&error){
            println("Could not save \(error), \(error?.userInfo)")
        }
        
    }
}