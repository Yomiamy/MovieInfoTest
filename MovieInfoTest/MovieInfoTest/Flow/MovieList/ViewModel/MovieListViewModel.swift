import Foundation
import RxSwift

class MovieListViewModel {
    
    // MARK:- Property
    
    private var model:MovieListModel!
    private var disposeBag:DisposeBag = DisposeBag()
    
    var movieListItemInfos:BehaviorSubject<[MovieListItemInfo]> = BehaviorSubject(value: [])
    
    // MARK:- Init Flow
    
    init(model:MovieListModel) {
        self.model = model
        
        self.bindingData()
    }
    
    private func bindingData() {
        self.model
            .movieListItemInfos
            .bind(to: self.movieListItemInfos)
            .disposed(by: self.disposeBag)
    }
    
    // MARK:- fetchMovieList
    func fetchMovieList(sortByIndex:Int) {
        let sortBy = self.sortByIndexMappingToStr(sortByIndex: sortByIndex)
        
        self.model.fetchMovieList(sortBy: sortBy)
    }
    
    // MARK:- resetAndFetchMovieList
    func resetAndFetchMovieList(sortByIndex:Int) {
        let sortBy = self.sortByIndexMappingToStr(sortByIndex: sortByIndex)
        
        self.model.resetAndFetchMovieList(sortBy: sortBy)
    }
    
    // MARK:- sortByIndexMappingToStr
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
