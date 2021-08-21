import UIKit
import Kingfisher

class MovieListItemCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    

    func setData(movieListItemInfo:MovieListItemInfo) {
        let imgUrl = movieListItemInfo.imageUrl
        let url = "\(Constants.IMG_SMALL_URL_PREFIX)\(imgUrl)"
        let title = movieListItemInfo.title
        let popularity = movieListItemInfo.popularity
        
        self.titleLabel.text = title
        self.popularityLabel.text = "\(popularity)"
        self.posterImageView.kf.setImage(with: URL(string: url))
    }

}
