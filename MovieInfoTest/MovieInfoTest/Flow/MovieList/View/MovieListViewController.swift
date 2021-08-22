import UIKit
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {
    
    private static let CELL_ID = "MovieListItemCell"

    // MARK:- Property
    @IBOutlet weak var movieListTableView: UITableView!
    @IBOutlet weak var sortBySegmentController: UISegmentedControl!
    private var refreshControl:UIRefreshControl!
    
    private var viewModel:MovieListViewModel!
    private var disposeBag:DisposeBag = DisposeBag()
    private var sortByIndex:Int = 0
    
    // MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.initData()
        self.bindingData()
        
        self.viewModel.fetchMovieList(sortByIndex: self.sortByIndex)
    }
    
    func initView() {
        self.navigationItem.title = "Movie List"
        self.refreshControl = UIRefreshControl()
        
        self.movieListTableView
            .rx
            .modelSelected(MovieListItemInfo.self)
            .subscribe { controlEvent in
                guard let movieId = controlEvent.element?.id else {
                    return
                }
                
                self.selectedMovieId = movieId
                self.performSegue(withIdentifier: Constants.ROUTE_SHOW_MOVIE_DETAIL, sender: self)
            }.disposed(by: self.disposeBag)
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
                if self.refreshControl.isRefreshing {
                    // 使用 UIView.animate 彈性效果，並且更改 TableView 的 ContentOffset 使其位移
                    UIView.animate(withDuration: 1,
                                   delay: 0,
                                   usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 1,
                                   options: .curveEaseIn,
                    animations: {
                        self.movieListTableView.contentOffset = CGPoint(x: 0, y: -self.refreshControl.bounds.height)
                    }) { _ in
                        self.refreshControl.endRefreshing()
                    }
                }
            })
            .bind(to: self.movieListTableView.rx.items(cellIdentifier: MovieListViewController.CELL_ID, cellType: MovieListItemCell.self)) { (index, movieListItemInfo, cell) in
                
                cell.setData(movieListItemInfo: movieListItemInfo)
                
                // Check whether or not contain last item in visible rows
                let isReachLast = self.movieListTableView.indexPathsForVisibleRows?.contains(where: { indexPath in
                    let totalCount = (try? self.viewModel.movieListItemInfos.value().count) ?? 0
                    
                    return indexPath.row == totalCount - 1
                }) ?? false
                
                if isReachLast {
                    self.viewModel.fetchMovieList(sortByIndex: self.sortByIndex)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    // MARK:- pullToRefresh
    @objc func pullToRefresh() {
        // 開始刷新動畫
        self.refreshControl.beginRefreshing()
        self.viewModel.resetAndFetchMovieList(sortByIndex: self.sortByIndex)
    }
    
    // MARK:- onSortByChange
    @IBAction func onSortByChange(_ sender: Any) {
        self.sortByIndex = self.sortBySegmentController.selectedSegmentIndex
        
        self.viewModel.resetAndFetchMovieList(sortByIndex: self.sortByIndex)
    }
}
