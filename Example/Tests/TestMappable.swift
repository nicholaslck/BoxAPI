//
//  TestMappable.swift
//  BoxAPI_Tests
//
//  Created by Nicholas Lau on 11/2/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import BoxAPI
import ObjectMapper


/**
 {
     id: 1,
     name: "TEST",
     type: "parent",
 }
 */
let jsonStringTest: String = "{\"name\": \"TEST\",\"id\":1,\"type\":\"parent\"}"

/**
 {
     name: "TEST",
     type: "parent",
 }
 */
let jsonStringTestNoID: String = "{\"name\": \"TEST\",\"type\":\"parent\"}"

/**
 {
     id: 1,
     name: "TEST",
     type: "parent",
     child: {
                 id: 2,
                 name: "CHILD",
                 type: "child",
            }
 }
 */
let jsonStringTestWithChild: String = "{\"name\": \"TEST\", \"id\":1, \"type\":\"parent\", \"child\":{\"name\": \"CHILD\", \"id\":2, \"type\":\"child\"}}"

/**
 {
     id: 1,
     name: "TEST",
     type: "parent",
     child:  {
                 name: "CHILD",
                 type: "child",
             }
 }
 */
let jsonStringTestWithChildNoID: String = "{\"name\": \"TEST\", \"id\":1, \"type\":\"parent\", \"child\":{\"name\": \"CHILD\", \"type\":\"child\"}}"

class TestMappable : BxMandatoryMappable {
    
    var name: String?
    
    var id: Int!
    
    var type: String?
    
    var child: TestMappable?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        type <- map["type"]
        child <- map["child"]
    }
    
    var mandatoryProperties: [Any?] {
        return [id]
    }
}
