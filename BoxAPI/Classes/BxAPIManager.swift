//
//  BxAPIManager.swift
//  BoxAPI
//
//  Created by Nicholas Lau on 31/1/2019.
//

import Foundation
import Alamofire

public protocol BxAPIManagerDelegate {
    
    /// delegate before each api request send. Return false if this api request should be block and drop.
    ///
    /// - Parameters:
    ///   - manager: BxAPIManager
    ///   - api: BoxAPI object
    /// - Returns: true for okay to send, else false.
    func bxAPIManager<T, U>(_ manager: BxAPIManager, apiReadyToFly api: BoxAPI<T, U>) -> Bool where T : BxRequestProtocol, U : BxResponseProtocol
    
    /// delegate after api return and before propagate to applications.
    ///
    /// - Parameters:
    ///   - manager: BxAPIManager
    ///   - api: BoxAPI object
    ///   - resumeHandler: a callback to application.
    /// - Returns: false if this api response should be dropped, else return true.
    func bxAPIManager<T, U>(_ manager: BxAPIManager, apiReturned api: BoxAPI<T, U>, resumeHandler: ((Bool) -> Void)? ) -> Bool where T : BxRequestProtocol, U : BxResponseProtocol
}

open class BxAPIManager {
    
    static let shared = BxAPIManager()
    
    var delegate: BxAPIManagerDelegate?
    
    open func send<T, U>( api: BoxAPI<T, U>, onReturn:((_ isSuccess: Bool) -> Void)? = nil ) where T : BxRequestProtocol, U : BxResponseProtocol {
        performSend(api: api, onReturn: onReturn)
    }
    
    private func performSend<T, U>( api: BoxAPI<T, U>, onReturn:((_ isSuccess: Bool) -> Void)? = nil ) where T : BxRequestProtocol, U : BxResponseProtocol {
        
        if !(self.delegate?.bxAPIManager(self, apiReadyToFly: api) ?? true) {
            return
        }
        
        guard let url = api.request.url else {
            api.status = .fail
            api.response = U()
            api.response!.error = bxAPIManagerError(description: "Invalid or no request url.")
            onReturn?(false)
            return
        }
        
        api.status = .waitingResponse
        
        let dataRequest = request(url, method: api.request.method, parameters: api.request.params, encoding: api.request.encoding, headers: api.request.customHeader)
        dataRequest.responseData { (dataResponse) in
            
            api.request.raw = dataRequest
            
            api.response = U()
            api.response!.raw = dataResponse
            api.response!.error = dataResponse.error
            api.response!.status = dataResponse.response!.statusCode
            api.response!.headers = dataResponse.response!.allHeaderFields as! [String: Any]
            api.response!.body = dataResponse.data
            
            var isSuccess = api.response!.error == nil
            
            if isSuccess, let verifyError = api.response!.verifyOnServerReturn() {
                isSuccess = false
                api.response!.error = verifyError
            }
            
            api.status = isSuccess ? .success : .fail
            
            if self.delegate?.bxAPIManager(self, apiReturned: api, resumeHandler: onReturn) ?? true {
               onReturn?(isSuccess)
            }
        }
    }
    
    private func bxAPIManagerError(description: String) -> NSError {
        
        return NSError(domain: "BxAPIManager", code: -1, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
}
