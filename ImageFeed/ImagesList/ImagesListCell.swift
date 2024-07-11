import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var dateLabel : UILabel?
    @IBOutlet var likeButton : UIButton?
    @IBOutlet var backgoundImage : UIImageView?
}
