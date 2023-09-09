import UIKit

struct CloseDetailViewEvent: EventProtocol {
    let payload: Void = ()
}

struct AddComentEvent: EventProtocol {
    struct Payload {
        let content: String
    }

    let payload: Payload
}

final class DetailViewController: TypedViewController<DetailView> {
    private var comments: [Comment] { CommentService.shared.comments }
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.comments = comments
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EventBus.shared.on(CloseDetailViewEvent.self, by: self) { listener, _ in
            listener.dismiss(animated: true)
        }
        EventBus.shared.on(AddComentEvent.self, by: self) { _, payload in
            guard let user = AuthService.shared.user else { return }
            CommentService.shared.addComment(user: user, content: payload.content, videoId: "asdasdsad")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        EventBus.shared.reset(self)
    }
}
