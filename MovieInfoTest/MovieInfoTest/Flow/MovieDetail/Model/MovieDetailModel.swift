import Foundation
import RxSwift

class MovieDetailModel {
    
    private var disposeBag:DisposeBag = DisposeBag()
    
    var movieDetailInfo:PublishSubject<MovieDetailInfo> = PublishSubject()
    
    func fetchMovieDetail(id:Int) {
        let id:String = "\(id)"
        let req:MovieDetailRequest = MovieDetailRequest(
            apiKey: Constants.API_KEY
        )
        
        ApiUtils.requestApi(apiType: MovieInfoApi.MovieDetail(id, ApiUtils.getBodyParams(obj: req)),
                                    responseType: MovieDetailInfo.self) { data in
            self.movieDetailInfo.onNext(data)
        } onFail: { error in
            print("Error")
        } onFinally: {
            print("Finish")
        }.disposed(by: disposeBag)
    }
}
