import Foundation

final class CommentService {
    static var shared: CommentService = .init()
    private init() {}

    @Publishable private(set) var comments: [Comment] = []

    private lazy var key: String = .init(describing: self)
    var storage: Storage? { didSet { comments = load() }}

    func comments(of video: YoutubeVideo) -> [Comment] {
        comments.filter { $0.videoId == video.id }
    }

    func add(comment: String, to video: YoutubeVideo, by user: User) {
        let comment = Comment(
            avatar: user.avatar,
            name: user.name,
            content: comment,
            videoId: video.id
        )
        comments.append(comment)
    }

    private func save(comments: [Comment]) {
        storage?.save(comments.map { $0.toModel() }, forKey: key)
    }

    private func load() -> [Comment] {
        guard let models: [CommentModel] = storage?.load(forKey: key) else { return [] }
        return models.compactMap { $0.toViewModel() }
    }
}
