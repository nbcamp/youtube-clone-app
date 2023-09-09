import Foundation

struct CommentModel {
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
