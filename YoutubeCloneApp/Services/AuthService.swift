import Foundation

final class AuthService {
    static var shared: AuthService = .init()
    private init() {}

    @Publishable private(set) var user: User?
    var isAuthenticated: Bool { user != nil }
    var storage: Storage?

    func login(email: String, password: String) {
        user = .init(
            name: "Anonymous",
            email: email,
            password: password
        )
    }
}
