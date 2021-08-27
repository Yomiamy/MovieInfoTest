import Foundation
import RxSwift

class MovieDetailViewModel {
    
    // MARK:- Property
    
    private var model:MovieDetailModel!
    private var disposeBag:DisposeBag = DisposeBag()
    
    var movieDetailInfo:PublishSubject<MovieDetailInfo> = PublishSubject()
    
    // MARK:- Init Flow
    init(model:MovieDetailModel) {
        self.model = model
        
        self.bindingData()
    }
    
    private func bindingData() {
        self.model
            .movieDetailInfo
            .bind(to: self.movieDetailInfo)
            .disposed(by: self.disposeBag)
    }
    
    // MARK:- fetchMovieDetail
    func fetchMovieDetail(id:Int) {
        self.model.fetchMovieDetail(id: id)
    }
}
