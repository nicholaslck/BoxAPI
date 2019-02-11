import XCTest
import BoxAPI

class BxAPIManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        BxAPIManager.shared.delegate = nil
    }
    
    func testBasicResponseContentsWhenAPIReturnsSuccess() {
        
        let expect = XCTestExpectation(description: "timeout")
        
        let api = TestAPI()
        api.request.userId = 2
        api.send { (isSuccess) in
            expect.fulfill()
            
            XCTAssertNotNil(api.request.raw)
            
            XCTAssertTrue(isSuccess)
            
            XCTAssertNotNil(api.response)
            
            let resp = api.response
            
            XCTAssertEqual(api.status, .succeed)
            XCTAssertNotNil(resp?.raw)
            XCTAssertEqual(resp?.statusCode, 200)
            XCTAssertNotNil(resp?.headers)
            XCTAssertNotNil(resp?.body)
            
            XCTAssertNil(resp?.error)
        }
        wait(for: [expect], timeout: 10)
    }
    
    func testBasicResponseContentsWhenAPIReturnsFail() {
        
        let expect = XCTestExpectation(description: "timeout")
        
        let api = TestAPI()
        api.request.userId = 123456789
        api.send { (isSuccess) in
            expect.fulfill()
            
            XCTAssertNotNil(api.request.raw)
            
            XCTAssertFalse(isSuccess)
            
            XCTAssertNotNil(api.response)
            
            let resp = api.response
            
            XCTAssertEqual(api.status, .failed)
            XCTAssertNotNil(resp?.raw)
            XCTAssertEqual(resp?.statusCode, 404)
            XCTAssertNotNil(resp?.headers)
            XCTAssertNotNil(resp?.body)
            
            XCTAssertNotNil(resp?.error)
            print(resp?.error ?? "")
        }
        wait(for: [expect], timeout: 10)
    }
    
    func testExitWhenAPIURLIsInvalid() {
        
        let expect = XCTestExpectation(description: "timeout")
        
        let api = TestAPI()
        api.request._domain = ""
        api.request._action = ""
        
        api.send { (isSuccess) in
            expect.fulfill()
            XCTAssertFalse(isSuccess)
            XCTAssertNotNil(api.response)
            XCTAssertNotNil(api.response?.error)
            XCTAssertEqual(api.response?.error?.localizedDescription, "Invalid or no request url.")
        }
        wait(for: [expect], timeout: 10)
    }
    
    func testAPIManagerShouldDropRequestWhenDelegateReadyToFlyReturnFalse() {
        
        let expect = XCTestExpectation(description: "timeout")
        
        let delegate = TestAPIDelegate()
        delegate.apiReadyToFly = false
        BxAPIManager.shared.delegate = delegate
        
        let api = TestAPI()
        
        api.send { (_) in
            expect.fulfill()
            XCTAssert(false, "The api should drop silently.")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
    
    func testAPIManagerShouldContinueRequestWhenDelegateReadyToFlyReturnTrue() {
        let expect = XCTestExpectation(description: "timeout")
        
        let delegate = TestAPIDelegate()
        delegate.apiReadyToFly = true
        BxAPIManager.shared.delegate = delegate
        
        let api = TestAPI()
        
        api.send { (_) in
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
    
    func testAPIManagerShouldDropResponseWhenDelegateAPIReturnReturnFalse() {
        let expect = XCTestExpectation(description: "timeout")
        
        let delegate = TestAPIDelegate()
        delegate.apiReturned = false
        BxAPIManager.shared.delegate = delegate
        
        let api = TestAPI()
        api.send { (_) in
            expect.fulfill()
            XCTAssert(false, "The api should drop silently.")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
    
    func testAPIManagerShouldContinueResponseWhenDelegateAPIReturnReturnTrue() {
        let expect = XCTestExpectation(description: "timeout")
        
        let delegate = TestAPIDelegate()
        delegate.apiReturned = true
        BxAPIManager.shared.delegate = delegate
        
        let api = TestAPI()
        api.send { (_) in
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
    
}


class TestAPIDelegate : BxAPIManagerDelegate {
    
    var apiReadyToFly = true
    
    var apiReturned = true
    
    func bxAPIManager<T, U>(_ manager: BxAPIManager, apiReadyToFly api: BoxAPI<T, U>) -> Bool where T : BxRequestProtocol, U : BxResponseProtocol {
        return apiReadyToFly
    }
    
    func bxAPIManager<T, U>(_ manager: BxAPIManager, apiReturned api: BoxAPI<T, U>, resumeHandler: ((Bool) -> Void)?) -> Bool where T : BxRequestProtocol, U : BxResponseProtocol {
        return apiReturned
    }
    
}
