import UIKit
import Kingfisher

class MovieListItemCell: UITableViewCell {
    
    // MARK:- Property
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voteForLabel: UILabel!
    
    // MARK:- setData
    func setData(movieListItemInfo:MovieListItemInfo) {
        let releaseDate = movieListItemInfo.releaseDate
        let imgUrl = movieListItemInfo.imageUrl
        let title = movieListItemInfo.title
        let popularity = movieListItemInfo.popularity
        let voteFor = "\(movieListItemInfo.voteCount)"
        
        self.releaseDateLabel.text = releaseDate
        self.titleLabel.text = title
        self.popularityLabel.text = "\(popularity)"
        self.posterImageView.kf.setImage(with: URL(string: imgUrl))
        self.voteForLabel.text = voteFor
        
        self.setSelected(false, animated: true)
    }

}
