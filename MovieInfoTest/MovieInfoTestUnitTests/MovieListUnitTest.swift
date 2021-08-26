import XCTest
@testable import MovieInfoTest
import RxSwift
import Network

class MovieListUnitTests: XCTestCase {
    
    var movieListModel:MovieListModel!
    var disposeBag:DisposeBag!
    var monitor: NWPathMonitor!
    

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.monitor = NWPathMonitor()
        self.monitor.start(queue: DispatchQueue.global())
        
        self.movieListModel = MovieListModel()
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        self.movieListModel = nil
        
        try super.tearDownWithError()
    }

    func testReleaseDateDesc() throws {
        let sortByReleaseDateDesc = "release_date.desc"
        
        testFetMovieList(sortBy: sortByReleaseDateDesc)
    }
    
    func testPopularityDesc() throws {
        let sortByPopularityDesc = "popularity.desc"
        
        testFetMovieList(sortBy: sortByPopularityDesc)
    }
    
    func testVoteCountDesc() throws {
        let sortByVoteCountDesc = "vote_count.descafadfaas"
        
        testFetMovieList(sortBy: sortByVoteCountDesc)
    }
    
    private func testFetMovieList(sortBy:String) {
        var errorMsg:String? = nil
        let promise = expectation(description: "API success")
        
        do {
            try XCTSkipUnless(self.monitor.currentPath.status == .satisfied, "Network connectivity needed for this test.")
        } catch {
            errorMsg = error.localizedDescription
            promise.fulfill()
        }
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var result:[MovieListItemInfo] = []
        
        self.movieListModel.movieListItemInfos.skip(1).subscribe { movieListInfos in
            result = movieListInfos
            promise.fulfill()
        } onError: { error in
            errorMsg = error.localizedDescription
            promise.fulfill()
        }.disposed(by: self.disposeBag)
        
        self.movieListModel.fetchMovieList(sortBy: sortBy)
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(errorMsg)
        XCTAssert(result.count > 0, "data is empty")
    }
}
