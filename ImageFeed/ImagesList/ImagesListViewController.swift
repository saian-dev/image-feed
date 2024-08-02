import UIKit


final class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"

    @IBOutlet private var tableView: UITableView!
    
    private let photosNames: [String] = Array(0..<20).map{"\($0)"}
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if indexPath.row >= photosNames.count {
            return
        }
        
        let photoName = photosNames[indexPath.row]
        cell.backgoundImage?.image = UIImage(named: photoName) ?? UIImage()
        cell.dateLabel?.text = dateFormatter.string(from: Date())
        
        let imageName: String = indexPath.row % 2 == 0 ? "fav_on" : "fav_off"
        cell.likeButton?.setImage(UIImage(named: imageName), for: .normal)
        
        cell.selectionStyle = .none
        
        if let gradientView = cell.gradientView, let dateLabel = cell.dateLabel {
            let gradient = CAGradientLayer()
            gradient.colors = [
                UIColor(hex: "#1A1B2233")!.cgColor,
                UIColor(hex: "#1A1B2200")!.cgColor,
            ]
            gradient.locations = [0.0, 0.3]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            
            gradient.frame = gradientView.bounds
            gradientView.layer.addSublayer(gradient)
            gradientView.bringSubviewToFront(dateLabel)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier { // 1
            guard
                let viewController = segue.destination as? SingleImageViewController, // 2
                let indexPath = sender as? IndexPath // 3
            else {
                assertionFailure("Invalid segue destination") // 4
                return
            }

            let image = UIImage(named: photosNames[indexPath.row]) // 5
            viewController.image = image // 6
        } else {
            super.prepare(for: segue, sender: sender) // 7
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosNames[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}
