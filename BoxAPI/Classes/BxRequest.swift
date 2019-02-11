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
    
    var encoding: ParameterEncoding { get }
}

public extension BxRequestProtocol {
    
    var url: URL? {
        
        guard let domainUrl = URL(string: self.domain) else {
            return nil
        }
        
        var domain = self.domain
        if domain.last != "/" {
            domain = "\(domain)/"
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
}

open class BxRequest : BxRequestProtocol {
    
    open var raw: DataRequest?
    
    /// Override this value if needed, default is GET.
    open var method: HTTPMethod {
        return .get
    }
    
    /// Override this value to config domain. e.g. For api "GET https://www.example.com/users/2", domain is "https://www.example.com"
    open var domain: String {
        return ""
    }
    
    /// Override this value to config action or path after domain. e.g. For api "GET https://www.example.com/users/2", action is "users/2"
    open var action: String {
        return ""
    }
    
    /// Override this method to assign params in request.
    open var params: [String: Any] {
        return [:]
    }
    
    open var customHeader: [String: String] {
        return [:]
    }
    
    /// Override this value if needed, default for POST and PUT will return JSONEncoding.default, else URLEncoding.default
    open var encoding: ParameterEncoding {
        
        switch method {
        case .post, .put:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    public required init() {
    }
    
}
