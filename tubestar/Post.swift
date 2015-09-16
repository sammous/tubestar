//
//  Post.swift
//  tubestar
//
//  Created by Sami MOUSTACHIR on 12/09/2015.
//  Copyright (c) 2015 Myintranet. All rights reserved.
//

import Foundation

class Post {
    var id:Int
    var name:String
    var tflid:String
    
    init(id:Int,name:String,tflid:String) {
        self.id = id
        self.name = name
        self.tflid = tflid
    }
    
    func toJSON() -> String {
        return "{\"Post\":{\"id\":\(id),\"name\":\"\(name)\",\"tflid\":\"\(tflid)\"}}"
    }
}