import UIKit
import RxSwift
import Kingfisher

class MovieDetailTableViewController: UITableViewController {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var releaseDataLabel: UILabel!
    

    private var disposeBag:DisposeBag = DisposeBag()
    private var viewModel:MovieDetailViewModel!
    var movieDetailInfo:PublishSubject<MovieDetailInfo> = PublishSubject()
    var movieListItemInfo:MovieListItemInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initData()
        self.bindingData()
        
        self.viewModel.fetchMovieDetail(id: self.movieListItemInfo.id)
    }
    
    func initView() {
        self.navigationItem.title = self.movieListItemInfo.title
        self.movieNameLabel.text = self.movieListItemInfo.title
        self.releaseDataLabel.text = self.movieListItemInfo.releaseDate
        
        self.posterImageView.kf.setImage(with: URL(string: self.movieListItemInfo.imageUrl))
    }
    
    func initData() {
        self.viewModel = MovieDetailViewModel(view: self)
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
