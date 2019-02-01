//
//  TestAPI.swift
//  BoxAPI
//
//  Created by Nicholas Lau on 1/2/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import BoxAPI
import ObjectMapper

class TestAPI: BoxAPI<TestRequest, TestResponse> {
}

class TestRequest : BxRequest {
    
    override var domain: String {
        return "https://reqres.in/"
    }
    
    override var action: String {
        return "/api/users/2"
    }
    
}

class TestResponse : BxJSONResponse<Test> {
}

class Test : Mappable {
    
//    "id": 2,
//    "first_name": "Janet",
//    "last_name": "Weaver",
//    "avatar": "https://s3.amazonaws.com/uifaces/faces/twitter/josephstein/128.jpg"
    var id: Int!
    var firstName: String!
    var lastName: String!
    var avatar: URL!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["data.id"]
        firstName <- map["data.first_name"]
        lastName <- map["data.last_name"]
        avatar <- map["data.avatar"]
    }
    
}
