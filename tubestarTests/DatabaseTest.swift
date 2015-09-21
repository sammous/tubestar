
//
//  DatabaseTest.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 17/09/2015.
//  Copyright © 2015 Myintranet. All rights reserved.
//

import Foundation
import XCTest
@testable import tubestar


class DatabaseTest: XCTestCase {
    
    func test_get_name_of_station() {
        
        let database = Database()
        let id:Int = 1
        XCTAssertEqual(database.get_name_of_station(id), "Angel Underground Station")
        
    }
    
    func test_get_name_of_line() {
        
        let database = Database()
        let id:Int = 1
        print("result is: \(database.get_name_of_station(id))")
        XCTAssertEqual(database.get_name_of_line(id), "Bakerloo")
        
    }
}