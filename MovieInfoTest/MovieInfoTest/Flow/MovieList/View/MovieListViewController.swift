import UIKit
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {
    
    private static let CELL_ID = "MovieListItemCell"

    // MARK:- Property
    @IBOutlet weak var movieListTableView: UITableView!
    private var refreshControl:UIRefreshControl!
    
    private var viewModel:MovieListViewModel!
    private var disposeBag:DisposeBag = DisposeBag()
    private var movieListItemInfos:BehaviorSubject<[MovieListItemInfo]> = BehaviorSubject(value: [])
    
    // MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.initData()
        self.bindingData()
        
        self.viewModel.fetchMovieList()
    }
    
    func initView() {
        self.navigationItem.title = "Movie List"
        self.refreshControl = UIRefreshControl()
        
        self.movieListTableView.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: UIControlEvents.valueChanged)
    }
    
    func initData() {
        self.viewModel = MovieListViewModel(view: self)
    }
    
    func bindingData() {
        self.viewModel
            .movieListItemInfos
            .do(onNext: { _ in
                self.refreshControl.endRefreshing()
            })
            .bind(to: self.movieListTableView.rx.items(cellIdentifier: MovieListViewController.CELL_ID, cellType: MovieListItemCell.self)) { (index, movieListItemInfo, cell) in
                cell.setData(movieListItemInfo: movieListItemInfo)
            }
            .disposed(by: self.disposeBag)
    }
    
    @objc func pullToRefresh() {
        // 開始刷新動畫
        self.refreshControl.beginRefreshing()
        
        // 使用 UIView.animate 彈性效果，並且更改 TableView 的 ContentOffset 使其位移
        // 動畫結束之後使用 loadData()
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseIn,
        animations: {
            self.movieListTableView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.bounds.height)
        }) { _ in
            self.viewModel.fetchMovieList()
        }
    }

}
