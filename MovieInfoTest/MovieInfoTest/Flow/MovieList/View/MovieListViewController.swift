import UIKit
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {
    
    private static let CELL_ID = "MovieListItemCell"

    // MARK:- Property
    @IBOutlet weak var movieListTableView: UITableView!
    
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
    }
    
    func initData() {
        self.viewModel = MovieListViewModel(view: self)
    }
    
    func bindingData() {
        self.viewModel
            .movieListItemInfos
            .bind(to: self.movieListTableView.rx.items(cellIdentifier: MovieListViewController.CELL_ID, cellType: MovieListItemCell.self)) { (index, movieListItemInfo, cell) in
                cell.setData(movieListItemInfo: movieListItemInfo)
            }
            .disposed(by: self.disposeBag)
    }

}
