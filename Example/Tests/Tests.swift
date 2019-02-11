import XCTest
import BoxAPI

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
        wait(for: [expect], timeout: 30)
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
        wait(for: [expect], timeout: 30)
    }
    
    func testExitWhenAPIURLIsInvalid() {
        
        let expect = XCTestExpectation(description: "timeout")
        
        let api = TestAPI()
        api.request._domain = "abc"
        
        api.send { (isSuccess) in
            expect.fulfill()
            XCTAssertFalse(isSuccess)
            XCTAssertNotNil(api.response)
            XCTAssertNotNil(api.response?.error)
        }
        wait(for: [expect], timeout: 30)
    }
}
