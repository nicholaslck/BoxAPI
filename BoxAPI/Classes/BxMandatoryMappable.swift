//
//  BxMandatoryMappable.swift
//  BoxAPI
//
//  Created by Nicholas Lau on 8/2/2019.
//

import Foundation
import ObjectMapper

public protocol BxMandatoryMappable : Mappable {
    
    var mandatoryProperties: [Any?] { get }
}

public extension BxMandatoryMappable {
    
    func verify() -> Error? {
        
        var error: Error? = nil
        
        // Check self mandatory field is empty or not.
        for (index, value) in mandatoryProperties.enumerated() {
            if value == nil {
                let thisError = bxMandatoryMappableError(description: "Value at index \(index) in mandatoryProperties in class \(type(of: self)) should not be nil.")
                print(thisError)
                if error == nil {
                    error = thisError
                }
            }
        }
        
        // Recursice verify all children.
        let mi = Mirror(reflecting: self)
        for child in mi.children {
            
            let name = child.label ?? ""
            var value: Any?
            
            // Unwrapped value from Child format.
            let childMi = Mirror(reflecting: child.value)
            if childMi.displayStyle == .optional , let (_, some) = childMi.children.first {
                value = some
            }
            
            if let manValue = value as? BxMandatoryMappable {
                // Verify child if it is single BxMandatoryMappable child
                if let thisError = manValue.verify() {
                    print(bxMandatoryMappableError(description: "Child property \(name) in object class \(type(of: self)) does not fullfill mandatoryProperties."))
                    if error == nil {
                        error = thisError
                    }
                }
            }
            else if let manValues = value as? [BxMandatoryMappable] {
                // Verify child if it is array of BxMandatoryMappable child
                for (index, manValue) in manValues.enumerated() {
                    if let thisError = manValue.verify() {
                        print(bxMandatoryMappableError(description: "Value at index \(index) of child property \(name) in object class \(type(of: self)) does not fullfill mandatoryProperties."))
                        if error == nil {
                            error = thisError
                        }
                    }
                }
            }
        }
        return error
    }
    
    private func bxMandatoryMappableError(description: String) -> NSError {
        
        return NSError(domain: "\(type(of: self))" , code: -3, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
