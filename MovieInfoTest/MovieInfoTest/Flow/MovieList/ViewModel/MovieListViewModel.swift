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
    
    func fetchMovieList(sortBy:String) {
        self.model.fetchMovieList(sortBy: sortBy)
    }
    
    func resetAndFetchMovieList(sortBy:String) {
        self.model.resetAndFetchMovieList(sortBy: sortBy)
    }
}
