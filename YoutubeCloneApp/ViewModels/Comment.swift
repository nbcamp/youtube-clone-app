import UIKit

final class Comment {
    var id: String
    var avatar: Base64?
    var name: String
    var content : String
    var videoId : String
    
    init(id: String, avatar: Base64?, name: String, content: String, videoId: String) {
        self.id = id
        self.avatar = avatar
        self.name = name
        self.content = content
        self.videoId = videoId
    }
}

extension Comment {
    var uiAvatar: UIImage? {
        get { avatar != nil ? .init(base64: avatar!) : nil }
        set { avatar = newValue?.base64 }
    }
}
