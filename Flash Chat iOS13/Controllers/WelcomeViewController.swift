import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - IBOutlets -

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - LifeCycle -
    
    // hide the nav bar only on this view when it appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // once this view disappear bring the nav bar back so it shows in the rest of the screen
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateLabel()
    }
    
    // MARK: - Helper Functions -
    
    // each letter appears on the screen after a small delay
    fileprivate func animateLabel() {
        self.titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "⚡️FlashChat"
        for letter in titleText {
            // the amount of time each letter needs to appear is getting increased based on charIndex
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
}
