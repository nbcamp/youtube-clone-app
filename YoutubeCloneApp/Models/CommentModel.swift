import Foundation

struct CommentModel: Codable {
    let id: String
    let avatar: Base64?
    let name: String
    let content : String
    let videoId : String
    
    init(from comment: Comment) {
        id = comment.id
        avatar = comment.avatar
        name = comment.name
        content = comment.content
        videoId = comment.videoId
    }
}

extension CommentModel {
    func toViewModel() -> Comment {
        return .init(
            id: id,
            avatar: avatar,
            name: name,
            content: content,
            videoId: videoId
        )
    }
}
