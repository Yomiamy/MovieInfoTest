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
    
    func fetchMovieList(sortByIndex:Int) {
        let sortBy = self.sortByIndexMappingToStr(sortByIndex: sortByIndex)
        
        self.model.fetchMovieList(sortBy: sortBy)
    }
    
    func resetAndFetchMovieList(sortByIndex:Int) {
        let sortBy = self.sortByIndexMappingToStr(sortByIndex: sortByIndex)
        
        self.model.resetAndFetchMovieList(sortBy: sortBy)
    }
    
    private func sortByIndexMappingToStr(sortByIndex:Int) -> String {
        switch sortByIndex {
        case 0:
            return "release_date.desc"
        case 1:
            return "popularity.desc"
        case 2:
            return "vote_count.desc"
        default:
            return "release_date.desc"
        }
    }
}
