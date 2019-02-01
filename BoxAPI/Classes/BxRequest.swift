//
//  BxRequest.swift
//  BoxAPI
//
//  Created by Nicholas Lau on 31/1/2019.
//

import Foundation
import Alamofire

public protocol BxRequestProtocol : AnyObject {
    
    init()
    
    var raw: DataRequest? { get set }
    
    var method: HTTPMethod { get }
    
    var domain: String { get }
    
    var action: String { get }
    
    var params: [String: Any] { get }
    
    var customHeader: [String: String] { get }
}

public extension BxRequestProtocol {
    
    var url: URL? {
        
        var domain = self.domain
        if domain.last != "/" {
            domain = "\(domain)/"
        }
        guard let domainUrl = URL(string: domain) else {
            return nil
        }
        
        var action = self.action
        for _ in action {
            if let firstChar = action.first, firstChar == "/" {
                action.removeFirst()
            }
            else {
                break
            }
        }
        
        return domainUrl.appendingPathComponent(action)
    }
    
    var encoding: ParameterEncoding {
        
        switch method {
        case .post, .put:
            return JSONEncoding()
        default:
            return URLEncoding()
        }
    }
}

open class BxRequest : BxRequestProtocol {
    
    open var method: HTTPMethod {
        return .get
    }
    
    open var domain: String {
        return BxAPIEnvironment.shared.domain
    }
    
    open var action: String {
        return ""
    }
    
    open var params: [String: Any] {
        return [:]
    }
    
    open var customHeader: [String: String] {
        return [:]
    }
    
    open var raw: DataRequest?
    
    public required init() {
    }
    
}
