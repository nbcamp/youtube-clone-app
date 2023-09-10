import UIKit

struct CloseDetailViewEvent: EventProtocol {
    let payload: Void = ()
}

struct AddCommentEvent: EventProtocol {
    struct Payload {
        let content: String
    }

    let payload: Payload
}

final class DetailViewController: TypedViewController<DetailView> {
    weak var video: YoutubeVideo? {
        didSet { rootView.configure(video: video) }
    }

    private var comments: [Comment] {
        guard let video else { return [] }
        return CommentService.shared.comments(of: video)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        rootView.comments = comments
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        EventBus.shared.on(CloseDetailViewEvent.self, by: self) { listener, _ in
            listener.dismiss(animated: true)
        }

        EventBus.shared.on(AddCommentEvent.self, by: self) { listener, payload in
            guard let video = listener.video, let user = AuthService.shared.user else { return }
            CommentService.shared.add(comment: payload.content, to: video, by: user)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        EventBus.shared.reset(self)
    }
    
    private func setupNavigation() {
        navigationItem.leftBarButtonItem = .init(image: .init(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .primary
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
