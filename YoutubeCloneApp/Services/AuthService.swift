import Foundation

class AuthService {
    static let shared = AuthService()

    @Publishable private(set) var user: User?
    var isAuthenticated: Bool { user != nil }

    private lazy var key: String = .init(describing: self)
    var storage: Storage? { didSet { user = load() } }
    var loading: Bool = false

    func signIn(
        email: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ) {
        loading = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in
            let user = self?.load()
            if user?.email == email, user?.password == password {
                self?.user = user
                completion(true)
            } else {
                completion(false)
            }
            self?.loading = false
        }
    }

    func signUp(
        avatar: Base64,
        name: String,
        email: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ) {
        loading = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.save(user: .init(avatar: avatar, name: name, email: email, password: password))
            self?.loading = false
            completion(true)
        }
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
