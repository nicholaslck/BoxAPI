//
//  BoxAPI.swift
//  BoxAPI
//
//  Created by Nicholas Lau on 31/1/2019.
//

import Foundation

open class BoxAPI<T, U> where T : BxRequestProtocol, U : BxResponseProtocol {
    
    enum Status {
        case ready
        case waitingResponse
        case successed
        case failed
    }
    
    var status: Status = .ready
    
    var request : T = T()
    var response : U?
}

// MARK:- API actions
public extension BoxAPI {
    
    func send(onReturn: () -> Void) {
        
    }
    
}
