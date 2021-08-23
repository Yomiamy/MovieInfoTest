import UIKit
import RxSwift

class MovieDetailTableViewController: UITableViewController {

    var id:String!
    
    private var disposeBag:DisposeBag = DisposeBag()
    private var viewModel:MovieDetailViewModel!
    var movieDetailInfo:PublishSubject<MovieDetailInfo> = PublishSubject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initData()
        self.bindingData()
        
        self.viewModel.fetchMovieDetail(id: self.movieListItemInfo.id)
    }
    
    func initView() {
        
    }
    
    func initData() {
    }
    
    func bindingData() {
        
        self.viewModel
            .movieDetailInfo
            .subscribe { controlEvent in
                guard let movieDetailInfo = controlEvent.element else {
                    return
                }
                
                self.synopsisLabel.text = movieDetailInfo.overview
                self.languageLabel.text = movieDetailInfo.spokenLanguagesStr
        }.disposed(by: self.disposeBag)

    }

}
