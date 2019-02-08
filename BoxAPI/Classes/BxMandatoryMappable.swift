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
        
        for (index, value) in mandatoryProperties.enumerated() {
            if value == nil {
                let thisError = bxMandatoryMappableError(description: "Value at mandatory mapping index \(index) in nil.")
                print(thisError)
                if error == nil {
                    error = thisError
                }
            }
        }
        
        let mi = Mirror(reflecting: self)
        for child in mi.children {
            let name = child.label ?? ""
            var value: Any? = child.value
            
            let childMi = Mirror(reflecting: child.value)
            if childMi.displayStyle == .optional {
                if let (_, some) = childMi.children.first {
                    value = some
                }
                else {
                    value = nil
                }
            }
            
            var childOk = true
            
            let recursiveBlock: ((BxMandatoryMappable) -> Void) = { (manValue) in
                if let thisError = manValue.verify() {
                    childOk = false
                    if error == nil {
                        error = thisError
                    }
                }
            }
            
            if let manValue = value as? BxMandatoryMappable {
                recursiveBlock(manValue)
            }
            else if let manValues = value as? [BxMandatoryMappable] {
                for manValue in manValues {
                    recursiveBlock(manValue)
                }
            }
            
            if !childOk {
                print(bxMandatoryMappableError(description: "Child property \(name) in object class \(type(of: self)) does not fullfill mandatory properties."))
            }
        }
        return error
    }
    
    private func bxMandatoryMappableError(description: String) -> NSError {
        
        return NSError(domain: "\(Mirror(reflecting: self).subjectType)" , code: -3, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
