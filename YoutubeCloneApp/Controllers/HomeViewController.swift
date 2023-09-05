import UIKit

final class HomeViewController: TypedViewController<HomeView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthService.shared.$user.subscribe(by: self) { (subscriber, user) in
            subscriber.rootView.user = user.new
        }
    }
}
