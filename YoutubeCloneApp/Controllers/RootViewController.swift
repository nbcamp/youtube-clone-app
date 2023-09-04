import UIKit

final class RootViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTabBarController()

        DispatchQueue.main.async {
            if !AuthService.shared.isAuthenticated {
                let signInVC = SignInViewController()
                signInVC.modalPresentationStyle = .fullScreen
                self.present(signInVC, animated: false)
            }
        }
    }

    private func initializeTabBarController() {
        let tabBarController = UITabBarController()

        let tabs: [(UIViewController.Type, String)] = [
            (HomeViewController.self, "house"),
            (ProfileViewController.self, "person"),
        ]

        tabBarController.setViewControllers(tabs.map { viewController, icon in
            let navigationController = UINavigationController(rootViewController: viewController.init())
            navigationController.tabBarItem = .init(title: nil, image: .init(systemName: icon), tag: 0)
            return navigationController
        }, animated: false)

        setViewControllers([tabBarController], animated: false)
    }
}
