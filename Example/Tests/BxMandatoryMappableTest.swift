//
//  BxMandatoryMappableTest.swift
//  BoxAPI_Tests
//
//  Created by Nicholas Lau on 11/2/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import ObjectMapper
import BoxAPI

class BxMandatoryMappableTest: XCTestCase {
    
    override func setUp() {
        
    }

    override func tearDown() {
        
    }
    
    func testBasicCaseWithoutChild() {
        let data = jsonStringTest.data(using: .utf8)!
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        print(json)
        
        let mappable = TestMappable(JSON: json as! [String: Any])
        
        XCTAssertNotNil(mappable)
        
        XCTAssertEqual(mappable?.id, 1)
        XCTAssertEqual(mappable?.name, "TEST")
        XCTAssertEqual(mappable?.type, "parent")
        
        XCTAssertNil(mappable?.verify())
    }

    func testShouldHaveErrorWhenMandatoryPropertiesNotFullfill() {
        
        let data = jsonStringTestNoID.data(using: .utf8)!
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        print(json)
        
        let mappable = TestMappable(JSON: json as! [String: Any])
        
        XCTAssertNotNil(mappable)
            
        let err = mappable?.verify()
        XCTAssertNotNil(err)
        XCTAssertEqual(err?.localizedDescription, "Value at index 0 in mandatoryProperties in class \(type(of: mappable)) should not be nil.")
    }
    
    func testBasicCaseWithChild() {
        
        let data = jsonStringTestWithChild.data(using: .utf8)!
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        print(json)
        
        let mappable = TestMappable(JSON: json as! [String: Any])
        
        XCTAssertNotNil(mappable)
        
        XCTAssertEqual(mappable?.id, 1)
        XCTAssertEqual(mappable?.name, "TEST")
        XCTAssertEqual(mappable?.type, "parent")
        
        XCTAssertNotNil(mappable?.child)
        guard let child = mappable?.child else {
            return
        }
        XCTAssertEqual(child.id, 2)
        XCTAssertEqual(child.name, "CHILD")
        XCTAssertEqual(child.type, "child")
        
        XCTAssertNil(child.verify())
        XCTAssertNil(mappable?.verify())
    }
    
    func testShouldHaveErrorWhenMandatoryProperiesInAnyChildNotFullfill() {
        
        let data = jsonStringTestWithChildNoID.data(using: .utf8)!
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        print(json)
        
        let mappable = TestMappable(JSON: json as! [String: Any])
        
        XCTAssertNotNil(mappable)
        XCTAssertEqual(mappable?.id, 1)
        XCTAssertEqual(mappable?.name, "TEST")
        XCTAssertEqual(mappable?.type, "parent")
        
        XCTAssertNotNil(mappable?.child)
        guard let child = mappable?.child else {
            return
        }
        XCTAssertEqual(child.name, "CHILD")
        XCTAssertEqual(child.type, "child")
        
        let childErr = child.verify()
        XCTAssertNotNil(childErr)
        XCTAssertEqual(childErr?.localizedDescription, "Value at index 0 in mandatoryProperties in class \(type(of: child)) should not be nil.")
        let parentErr = mappable?.verify()
        XCTAssertNotNil(parentErr)
        XCTAssertEqual(parentErr?.localizedDescription, "Value at index 0 in mandatoryProperties in class \(type(of: child)) should not be nil.")
    }

}
