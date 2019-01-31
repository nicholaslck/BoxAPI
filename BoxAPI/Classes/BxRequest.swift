//
//  BxRequest.swift
//  BoxAPI
//
//  Created by Nicholas Lau on 31/1/2019.
//

import Foundation

public protocol BxRequestProtocol : AnyObject {
    
    init()
    
    var method: String { get set }
    
    var domain: String { get set }
    
    var action: String { get set }
    
    var queries: Dictionary<String, Any> { get set }
    
    var customHeader: Dictionary<String, Any> { get set }
    
    var raw: Any? { get set }
}

public extension BxRequestProtocol {
    
    var url: URL? {
        guard let domainUrl = URL(string: domain) else {
            return nil
        }
        return domainUrl.appendingPathComponent(action)
    }
    
}
