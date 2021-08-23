import Foundation
import RxSwift

class MovieDetailViewModel {
    
    private weak var view:MovieDetailTableViewController!
    private var model:MovieDetailModel!
    private var disposeBag:DisposeBag = DisposeBag()
    
    var movieDetailInfo:PublishSubject<MovieDetailInfo> = PublishSubject()
    
    init(view:MovieDetailTableViewController) {
        self.view = view
        self.model = MovieDetailModel()
        
        self.model
            .movieDetailInfo
            .bind(to: self.movieDetailInfo)
            .disposed(by: self.disposeBag)
    }
    
    func fetchMovieDetail(id:Int) {
        self.model.fetchMovieDetail(id: id)
    }
}
