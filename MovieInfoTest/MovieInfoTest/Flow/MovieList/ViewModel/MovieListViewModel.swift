import Foundation
import RxSwift

class MovieListViewModel {
    
    private weak var view:MovieListViewController!
    private var model:MovieListModel!
    private var disposeBag:DisposeBag = DisposeBag()
    
    var movieListItemInfos:BehaviorSubject<[MovieListItemInfo]> = BehaviorSubject(value: [])
    
    init(view:MovieListViewController) {
        self.view = view
        self.model = MovieListModel()
        
        self.model
            .movieListItemInfos
            .bind(to: self.movieListItemInfos)
            .disposed(by: self.disposeBag)
    }
    
    func fetchMovieList() {
        self.model.fetchMovieList(date: "2016-12-31", sortType: "release_date.desc", page: 1)
    }
}
