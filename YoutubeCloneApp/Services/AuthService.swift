import Foundation

class AuthService {
    static let shared = AuthService()

    @Publishable private(set) var user: User?
    var isAuthenticated: Bool { user != nil }
    var storage: Storage?

    func signIn(
        email: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(true)
        }
    }

    func signUp(
        avatar: Base64,
        name: String,
        email: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            self.user = User(avatar: avatar, name: name, email: email, password: password)
            completion(true)
        }
    }
}
