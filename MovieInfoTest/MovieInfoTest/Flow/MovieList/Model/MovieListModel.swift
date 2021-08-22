import Foundation
import RxSwift

class MovieListModel {
    
    private var disposeBag:DisposeBag = DisposeBag()
    var movieListItemInfos:BehaviorSubject<[MovieListItemInfo]> = BehaviorSubject(value: [])
    
    func fetchMovieList(date:String, sortType:String, page:Int) {
    func fetchMovieList(sortBy:String) {
        let req:MovieListRequest = MovieListRequest(
            apiKey: Constants.API_KEY,
            primaryReleaseDate: date,
            sortBy: sortType,
            page: page
        )
        
        ApiUtils.requestApi(apiType: MovieInfoApi.MovieList(ApiUtils.getBodyParams(obj: req)), responseType: MovieSummaryInfo.self) { movieSummaryInfo in
            self.movieListItemInfos.onNext(movieSummaryInfo.results)
        } onFail: { error in
            print("Error")
        } onFinally: {
            print("Finish")
        }.disposed(by: disposeBag)
    }
}
