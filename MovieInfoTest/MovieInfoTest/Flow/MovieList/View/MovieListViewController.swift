import UIKit
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {
    
    private static let CELL_ID = "MovieListItemCell"
    private static let NAV_TITLE = "Movie List"

    // MARK:- Property
    @IBOutlet weak var movieListTableView: UITableView!
    @IBOutlet weak var sortBySegmentController: UISegmentedControl!
    private var refreshControl:UIRefreshControl!
    
    private var viewModel:MovieListViewModel!
    private var disposeBag:DisposeBag = DisposeBag()
    private var sortByIndex:Int = 0
    private var selectedMovieListItemInfo:MovieListItemInfo?
    
    // MARK:- Init Flow
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.initData()
        self.bindingData()
        
        self.fetchMovieList()
    }
    
    func initView() {
        self.navigationItem.title = MovieListViewController.NAV_TITLE
        self.refreshControl = UIRefreshControl()
        
        self.movieListTableView
            .rx
            .modelSelected(MovieListItemInfo.self)
            .subscribe { controlEvent in
                guard let movieListItemInfo = controlEvent.element else {
                    return
                }
                
                self.selectedMovieListItemInfo = movieListItemInfo
                self.performSegue(withIdentifier: Constants.ROUTE_SHOW_MOVIE_DETAIL, sender: self)
            }.disposed(by: self.disposeBag)
        self.movieListTableView.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: UIControlEvents.valueChanged)
    }
    
    func initData() {
        self.viewModel = MovieListViewModel(model: .init())
    }
    
    func bindingData() {
        self.viewModel
            .movieListItemInfos
            .do(onNext: { _ in
                self.closeLoading()
                
                if self.refreshControl.isRefreshing {
                    // Reset the offset of TableView
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
            }, onError: { error in
                print("Error is \(error.localizedDescription)")
                
                self.closeLoading()
                self.refreshControl.endRefreshing()
            })
            .bind(to: self.movieListTableView.rx.items(cellIdentifier: MovieListViewController.CELL_ID, cellType: MovieListItemCell.self)) { (index, movieListItemInfo, cell) in
                
                cell.setData(movieListItemInfo: movieListItemInfo)
                
                // Check whether or not contain last item in visible rows
                let isReachLast = self.movieListTableView.indexPathsForVisibleRows?.contains(where: { indexPath in
                    let totalCount = (try? self.viewModel.movieListItemInfos.value().count) ?? 0
                    
                    return indexPath.row == totalCount - 1
                }) ?? false
                
                if isReachLast {
                    self.fetchMovieList(isNeedLoading: false)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    // MARK:- Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailVc = segue.destination as? MovieDetailTableViewController,
           let selectedMovieListItemInfo = self.selectedMovieListItemInfo {
            movieDetailVc.movieListItemInfo = selectedMovieListItemInfo
        }
    }
    
    // MARK:- fetchMovieList
    private func fetchMovieList(isNeedLoading:Bool = true) {
        if isNeedLoading {
            self.showLoading()
        }
        
        self.viewModel.fetchMovieList(sortByIndex: self.sortByIndex)
    }
    
    // MARK:- pullToRefresh
    @objc func pullToRefresh() {
        // Start Refreshing
        self.refreshControl.beginRefreshing()
        self.viewModel.resetAndFetchMovieList(sortByIndex: self.sortByIndex)
    }
    
    // MARK:- onSortByChange
    @IBAction func onSortByChange(_ sender: Any) {
        self.sortByIndex = self.sortBySegmentController.selectedSegmentIndex
        
        self.viewModel.resetAndFetchMovieList(sortByIndex: self.sortByIndex)
    }
}
