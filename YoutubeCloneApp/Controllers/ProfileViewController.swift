import UIKit

final class ProfileViewController: TypedViewController<ProfileView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AuthService.shared.$user.subscribe(by: self, immediate: true) { subscriber, user in
            if let user = user.new {
                subscriber.rootView.configure(user: user)
            }
        }
    }
}
