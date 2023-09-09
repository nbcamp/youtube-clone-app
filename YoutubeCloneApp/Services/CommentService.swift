import Foundation

final class CommentService {
    static var shared : CommentService = .init()
    private init() {}
    
    @Publishable private(set) var comments: [Comment] = []
    var storage: Storage?
    
    func showComments (videoId : String) -> [Comment] {
        comments.filter{$0.videoId == videoId}
    }
    
    func addComment(user: User, content: String, videoId: String) {
        let comment : Comment = Comment(id: "1", avatar: user.avatar, name: user.name, content: content, videoId: videoId)
        comments.append(comment)
    }
}
