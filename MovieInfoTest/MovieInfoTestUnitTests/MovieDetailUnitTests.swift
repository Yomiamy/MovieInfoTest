import XCTest
@testable import MovieInfoTest
import RxSwift
import Network

class MovieDetailUnitTests: XCTestCase {
    
    var movieDetail:MovieDetailModel!
    var disposeBag:DisposeBag!
    var monitor: NWPathMonitor!

    override func setUpWithError() throws {
        self.monitor = NWPathMonitor()
        self.monitor.start(queue: DispatchQueue.global())
        
        self.movieDetail = MovieDetailModel()
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetMovieDetail() throws {
        var result:MovieDetailInfo? = nil
        var errorMsg:String? = nil
        let promise = expectation(description: "API success")
        
        do {
            try XCTSkipUnless(self.monitor.currentPath.status == .satisfied, "Network connectivity needed for this test.")
            
            self.movieDetail.movieDetailInfo.subscribe { movieDetailInfo in
                result = movieDetailInfo
                
                promise.fulfill()
            } onError: { error in
                errorMsg = error.localizedDescription
                promise.fulfill()
            }.disposed(by: self.disposeBag)
        } catch {
            errorMsg = "No Network Error"
            promise.fulfill()
        }
    
        self.movieDetail.fetchMovieDetail(id: 328111)
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(errorMsg)
        XCTAssertNotNil(result)
    }

}
