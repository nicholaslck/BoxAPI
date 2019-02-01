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
    
    func testExample() {
        
        let expect = XCTestExpectation(description: "cc")
        
        let api = TestAPI()
        api.send { (isSuccess) in
            XCTAssertTrue(isSuccess, "API return fail.")
            
            XCTAssertEqual(api.response?.json?.id, 2, "Wrong Id.")
            
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 20)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
