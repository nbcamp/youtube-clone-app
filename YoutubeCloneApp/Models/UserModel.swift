struct UserModel: Codable {
    let avatar: Base64?
    let name: String
    let email: String
    let password: String

    init(from user: User) {
        avatar = user.avatar
        name = user.name
        email = user.email
        password = user.password
    }
}

extension UserModel {
    func toViewModel() -> User {
        return .init(
            avatar: avatar,
            name: name,
            email: email,
            password: password
        )
    }
}
