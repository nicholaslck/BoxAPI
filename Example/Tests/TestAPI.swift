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
    
    var userId: Int = 0
    
    var _domain = "https://reqres.in/"
    
    var _action = "/api/users/"
    
    override var domain: String {
        return _domain
    }
    
    override var action: String {
        return "\(_action)\(userId)"
    }
    
}

class TestResponse : BxJSONResponse<Test> {
}

class Test : BxMandatoryMappable {
    
    var mandatoryProperties: [Any?] {
        return []
    }
    
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
