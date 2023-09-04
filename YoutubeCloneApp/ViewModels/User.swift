import UIKit

final class User {
    @Publishable var avatar: Base64?
    @Publishable var name: String
    @Publishable var email: String
    var password: String

    init(avatar: Base64? = nil, name: String, email: String, password: String) {
        self.avatar = avatar
        self.name = name
        self.email = email
        self.password = password
    }
}

extension User {
    var uiAvatar: UIImage? {
        get { avatar != nil ? .init(base64: avatar!) : nil }
        set { avatar = newValue?.base64 }
    }
}

