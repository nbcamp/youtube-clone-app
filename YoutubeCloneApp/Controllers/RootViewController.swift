import UIKit

final class RootViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTabBarController()

        DispatchQueue.main.async {
            if !AuthService.shared.isAuthenticated {
                let navigationController = UINavigationController()
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.setViewControllers([SignInViewController()], animated: true)
                self.present(navigationController, animated: false)
            }
        }
    }

    private func initializeTabBarController() {
        let tabs: [(UIViewController.Type, String)] = [
            (HomeViewController.self, "house"),
            (ProfileViewController.self, "person"),
        ]

        setViewControllers(tabs.map { viewController, icon in
            let navigationController = UINavigationController(rootViewController: viewController.init())
            navigationController.tabBarItem = .init(title: nil, image: .init(systemName: icon), tag: 0)
            return navigationController
        }, animated: false)
    }
}
