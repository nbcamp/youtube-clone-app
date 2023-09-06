import Foundation

class AuthService {
    static let shared = AuthService()

    private let users: [String: String] = [
        "0202dy@naver.com": "0202dy",
    ]

    private var _isAuthenticated = false

    var isAuthenticated: Bool {
        return _isAuthenticated
    }

    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let storedPassword = self.users[email]
            let signInSuccess = storedPassword == password
            self._isAuthenticated = signInSuccess
            completion(signInSuccess)
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            if self.users[email] == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
