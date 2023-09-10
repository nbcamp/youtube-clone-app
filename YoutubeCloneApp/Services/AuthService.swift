import Foundation

final class AuthService {
    static let shared = AuthService()
    private init() {}

    @Publishable private(set) var user: User?
    var isAuthenticated: Bool { user != nil }

    enum AuthError: Error {
        case invalidEmail
        case invalidPassword
        case userNotFound
        case incorrectInput
    }

    private lazy var key: String = .init(describing: self)
    var storage: Storage? { didSet { user = load() } }
    var loading: Bool = false

    func signIn(
        email: String,
        password: String,
        completion: @escaping (AuthError?) -> Void
    ) {
        loading = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in
            let user = self?.load()
            guard let user else { completion(.userNotFound); return }
            guard user.email == email,
                  user.password == password
            else { completion(.incorrectInput); return }
            completion(nil)
            self?.loading = false
        }
    }

    func signUp(
        avatar: Base64,
        name: String,
        email: String,
        password: String,
        completion: @escaping (AuthError?) -> Void
    ) {
        loading = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard email.test(pattern: .email) else { completion(.invalidEmail); return }
            guard password.test(pattern: .password) else { completion(.invalidPassword); return }

            self?.save(user: .init(
                avatar: avatar,
                name: name,
                email: email,
                password: password
            ))
            self?.loading = false
            completion(nil)
        }
    }

    func update(user: User) {
        guard let authUser = self.user else { return }
        if !user.email.test(pattern: .email) { user.email = authUser.email }
        if !user.password.test(pattern: .password) { user.password = authUser.password }
        self.user = user
        save(user: user)
    }

    private func save(user: User?) {
        guard let model = user?.toModel() else { return }
        storage?.save(model, forKey: key)
    }

    private func load() -> User? {
        guard let model: UserModel = storage?.load(forKey: key) else { return nil }
        return model.toViewModel()
    }
}
