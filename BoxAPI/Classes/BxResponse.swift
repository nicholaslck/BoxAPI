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
    
    var statusCode: Int { get set }
    
    var error: Error? { get set }
    
    var headers: [String : Any] { get set }
    
    var body: Data? { get set }
}

open class BxResponse : BxResponseProtocol {
    
    open var raw: DataResponse<Data>?
    
    open var statusCode: Int = 0
    
    open var error: Error?
    
    open var headers: [String : Any] = [:]
    
    open var body: Data?
    
    public required init() {
    }
}

public protocol BxJSONResponseProtocol : BxResponseProtocol {
    
    associatedtype JSONObjectType : Mappable
    
    var json: JSONObjectType? { get }
}

open class BxJSONResponse<J> : BxResponse, BxJSONResponseProtocol where J : Mappable {
    
    public typealias JSONObjectType = J
    
    /// A JSON representation of body, if body cannot convert to JSON or body is nil, it returns nil.
    open private(set) var json: J?
    
    override open var body: Data? {
        didSet {
            json = nil
            if body != nil {
                do {
                    json = try convertDataToJSON()
                    
                    if let manJson = json as? BxMandatoryMappable {
                        if let verifyError = manJson.verify() {
                            throw verifyError
                        }
                    }
                }
                catch {
                    print(error)
                    if self.error == nil {
                        self.error = error
                    }
                }
            }
        }
    }
    
    public required init() {
        super.init()
    }
    
    private func bxJSONResponseError(description: String) -> NSError {
        
         return NSError(domain: "BxJSONResponse", code: -2, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    private func convertDataToJSON() throws -> J? {
        
        guard let data = body else { return nil }
        
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let jsonDict = jsonObject as? [String : Any] else {
            if let _ = jsonObject as? [Any] {
                throw bxJSONResponseError(description: "Cannot parse JSON using ObjectMapper, body is a JSON array.")
            }
            else {
                throw bxJSONResponseError(description: "Cannot parse JSON using ObjectMapper, body is a single value \(String(describing: jsonObject))")
            }
        }
        return J(JSON: jsonDict)
    }
}


