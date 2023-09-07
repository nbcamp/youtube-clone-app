import UIKit

final class DetailViewController: TypedViewController<DetailView> {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EventBus.shared.on(CloseDetailViewEvent.self, by: self) { (listener, payload) in
            listener.dismiss(animated: true)
        }
    }
}
