import UIKit

final class HomeViewController: TypedViewController<HomeView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthService.shared.$user.subscribe(by: self) { (subscriber, user) in
            subscriber.rootView.user = user.new
        }
    }
    
    //동작정의
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        EventBus.shared.on(PushToDetailViewEvent.self, by: self) { (listener, payload) in
            listener.navigationController?.pushViewController(DetailViewController(), animated: true)
        }
        
        EventBus.shared.on(CollectionViewRefresh.self, by: self) { (listener, payload) in
//            let refreshControl = UIRefreshControl()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        EventBus.shared.reset(self)
    }
}


