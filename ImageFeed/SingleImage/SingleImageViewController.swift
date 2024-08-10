import UIKit


final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var goBackButton: UIButton!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet weak var shareButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        guard let image else {return}
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image else { return }

        let shareSheet = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(shareSheet, animated: true, completion: nil)
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}


extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetTop = max((scrollView.bounds.height - scrollView.contentSize.height) / 2, 0)
        let offsetLeft = max((scrollView.bounds.width - scrollView.contentSize.width) / 2, 0)
        
        scrollView.contentInset = UIEdgeInsets(top: offsetTop, left: offsetLeft, bottom: 0, right: 0)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}
