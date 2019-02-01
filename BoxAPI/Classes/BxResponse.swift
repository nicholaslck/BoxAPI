//
//  BxResponse.swift
//  BoxAPI
//
//  Created by Nicholas Lau on 31/1/2019.
//

import Foundation
import Alamofire
import ObjectMapper

public protocol BxResponseProtocol : AnyObject {
    
    init()
    
    var raw: DataResponse<Data>? { get set }
    
    var status: Int { get set }
    
    var error: Error? { get set }
    
    var headers: [String : Any] { get set }
    
    var body: Data? { get set }
}

open class BxResponse : BxResponseProtocol {
    
    open var raw: DataResponse<Data>?
    
    open var status: Int = 0
    
    open var error: Error?
    
    open var headers: [String : Any] = [:]
    
    open var body: Data?
    
    public required init() {
        status = 0
    }
}

public protocol BxJSONResponseProtocol : BxResponseProtocol {
    
    associatedtype JSONObjectType : Mappable
    
    var json: JSONObjectType? { get }
}

open class BxJSONResponse<J> : BxResponse, BxJSONResponseProtocol where J : Mappable {
    
    public typealias JSONObjectType = J
    
    private var _json: J?
    
    /// A JSON representation of body, if body cannot convert to JSON or body is nil, it returns nil.
    open var json: J? {
        if _json == nil {
            
            guard let data = body else { return nil }
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let jsonDict = jsonObject as? [String : Any] {
                    _json = Mapper<J>().map(JSON: jsonDict)
                }
                else if let _ = jsonObject as? [Any] {
                    throw bxJSONResponseError(description: "Cannot parse JSON using ObjectMapper, body is a JSON array.")
                }
                else {
                    throw bxJSONResponseError(description: "Cannot parse JSON using ObjectMapper, body is a single value \(String(describing: jsonObject))")
                }
            }
            catch {
                print(error)
            }
        }
        return _json
    }
    
    override open var body: Data? {
        didSet {
            _json = nil
        }
    }
    
    public required init() {
        super.init()
    }
    
    private func bxJSONResponseError(description: String) -> NSError {
        
         return NSError(domain: "BxJSONResponse", code: -2, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
}


