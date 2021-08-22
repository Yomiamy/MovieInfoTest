import Foundation
import RxSwift

class MovieListModel {
    
    private var disposeBag:DisposeBag = DisposeBag()
    var movieListItemInfos:BehaviorSubject<[MovieListItemInfo]> = BehaviorSubject(value: [])
    
    private var page:Int = 0
    
    func fetchMovieList(sortBy:String) {
        self.page += 1
        
        let req:MovieListRequest = MovieListRequest(
            apiKey: Constants.API_KEY,
            primaryReleaseDate: "2016-12-31",
            sortBy: sortBy,
            page: page
        )
        
        ApiUtils.requestApi(apiType: MovieInfoApi.MovieList(ApiUtils.getBodyParams(obj: req)), responseType: MovieSummaryInfo.self) { movieSummaryInfo in
            let newMovieListItemInfos = movieSummaryInfo.results
            
            // If new movieListItemInfos is
            if newMovieListItemInfos.count > 0 {
                var currentMovieListItemInfos = (try? self.movieListItemInfos.value()) ?? []
                
                currentMovieListItemInfos.append(contentsOf: newMovieListItemInfos)
                self.movieListItemInfos.onNext(currentMovieListItemInfos)
            } else {
                // Reset the page to previous
                self.page -= 1
            }
        } onFail: { error in
            // Reset the page to previous
            self.page -= 1
            
            print("Error")
        } onFinally: {
            print("Finish")
        }.disposed(by: disposeBag)
    }
    
    func resetAndFetchMovieList(sortBy:String) {
        // Reset to init page index
        self.page = 0
        
        // Notify to reset list
        self.movieListItemInfos.onNext([])
        // Fetch in init page index
        self.fetchMovieList(sortBy: sortBy)
    }
}
