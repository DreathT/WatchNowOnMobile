import UIKit
import WebKit

class VideoPlayerViewController: UIViewController {

    var videoId: String? // Tıklanan videonun ID'si buraya atanacak
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let videoId = videoId {
            let urlString = "https://www.youtube.com/embed/\(videoId)"
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
}

