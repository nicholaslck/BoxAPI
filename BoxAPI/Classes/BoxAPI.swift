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
        case successed
        case failed
    }
    
    open var status: Status = .ready
    
    open var request : T = T()
    open var response : U?
    
    public init() {
    }
    
    open func send(onReturn: ((Bool) -> Void)? ) {
        
        BxAPIManager.shared.send(api: self, onReturn: onReturn)
    }
}
