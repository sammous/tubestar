
//
//  Database.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 02/09/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Database {
    
    func get_name_of_station(id: Int) -> String {
        var station: String = ""
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"Station")
        let resultPredicate = NSPredicate(format: "id = \(id)")
        fetchRequest.predicate = resultPredicate
        do {
            let fetchedResults =
            try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if (fetchedResults?.count !== 0)  {
                station = fetchedResults?.first!.valueForKey("name") as! String
            }

        } catch {
            print(error)
        }
        
        return station
    }
    
    func get_name_of_line(id: Int) -> String {
        var line: String = ""
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"Line")
        let resultPredicate = NSPredicate(format: "id = \(id)")
        fetchRequest.predicate = resultPredicate
        do {
            let fetchedResults =
            try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if (fetchedResults?.count !== 0)  {
                line = fetchedResults?.first!.valueForKey("name") as! String
            }
            
        } catch {
            print(error)
        }
        print("lines is \(line)")
        return line
    }


}