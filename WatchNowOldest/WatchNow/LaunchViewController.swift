import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Butona basıldığında çağrılacak fonksiyon
    @IBAction func watchNowButtonTapped(_ sender: UIButton) {
        navigateToMain()
    }

    // Ana sayfaya geçişi yapan fonksiyon
    func navigateToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }
}

