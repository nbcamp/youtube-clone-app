import UIKit

struct PushToDetailViewEvent: EventProtocol {
    let payload: Void = ()
}

struct RefreshVideos: EventProtocol {
    let payload: Void = ()
}

final class HomeViewController: TypedViewController<HomeView> {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        EventBus.shared.on(PushToDetailViewEvent.self, by: self) { listener, _ in
            listener.navigationController?.pushViewController(DetailViewController(), animated: true)
        }

        EventBus.shared.on(RefreshVideos.self, by: self) { _, _ in
            // 리프레시 EventBus로 옮기기 실패..
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        EventBus.shared.reset(self)
    }
}
