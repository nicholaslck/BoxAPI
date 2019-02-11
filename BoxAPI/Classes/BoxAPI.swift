//
//  BoxAPI.swift
//  BoxAPI
//
//  Created by Nicholas Lau on 31/1/2019.
//

import Foundation
import ObjectMapper

open class BoxAPI<T, U> where T : BxRequestProtocol, U : BxResponseProtocol {
    
    public enum Status {
        case ready
        case waitingResponse
        case succeed
        case failed
    }
    
    open var status: Status = .ready
    
    open var request : T = T()
    open var response : U?
    
    public init() {
    }
    
    /// Perform send api action. You can check api status in onReturn: to determine if api is success or not.
    ///
    /// - Parameters:
    ///   - apiManager: BxAPIManager, default is BxAPIManager.shared
    ///   - onReturn: A block object to be executed when the api returns. This block has no return value and takes a single Boolean argument that indicates whether or not the api success or not.
    open func send(by apiManager: BxAPIManager = BxAPIManager.shared, onReturn: ((Bool) -> Void)? ) {
        
        BxAPIManager.shared.send(api: self, onReturn: onReturn)
    }
}
