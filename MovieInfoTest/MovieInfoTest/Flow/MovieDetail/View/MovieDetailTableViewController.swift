import UIKit
import RxSwift
import Kingfisher

class MovieDetailTableViewController: UITableViewController {

    // MARK:- Property
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var releaseDataLabel: UILabel!

    private var disposeBag:DisposeBag = DisposeBag()
    private var viewModel:MovieDetailViewModel!
    var movieDetailInfo:MovieDetailInfo?
    var movieListItemInfo:MovieListItemInfo!
    
    // MARK:- Init Flow
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initData()
        self.bindingData()
        
        self.showLoading()
        self.viewModel.fetchMovieDetail(id: self.movieListItemInfo.id)
    }
    
    func initView() {
        self.navigationItem.title = self.movieListItemInfo.title
        self.movieNameLabel.text = self.movieListItemInfo.title
        self.releaseDataLabel.text = self.movieListItemInfo.releaseDate
        
        self.posterImageView.kf.setImage(with: URL(string: self.movieListItemInfo.imageUrl))
    }
    
    func initData() {
        self.viewModel = MovieDetailViewModel()
    }
    
    func bindingData() {
        self.viewModel
            .movieDetailInfo
            .do(onNext: { _ in
                self.closeLoading()
            }, onError: { error in
                print("Error is \(error.localizedDescription)")
                self.closeLoading()
            })
            .subscribe { controlEvent in
                guard let movieDetailInfo = controlEvent.element else {
                    return
                }
                
                self.movieDetailInfo = movieDetailInfo
                self.synopsisLabel.text = movieDetailInfo.overview
                self.languageLabel.text = movieDetailInfo.spokenLanguagesStr
                self.genresLabel.text = movieDetailInfo.genresStr
        }.disposed(by: self.disposeBag)

    }
    
    // MARK:- Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webviewVc = segue.destination as? WebViewController,
           let movieDetailInfo = self.movieDetailInfo {
            webviewVc.titleStr = movieDetailInfo.title
            webviewVc.urlStr = movieDetailInfo.bookMovieUrl
        }
    }
    
    // MARK:- onBookClick
    @IBAction func onBookClick(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.ROUTE_SHOW_WEB_VIEW, sender: self)
    }
}
