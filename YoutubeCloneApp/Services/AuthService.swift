import Foundation

final class AuthService {
    static var shared: AuthService = .init()
    private init() {}
    
    private(set) var user: User?
    var isAuthenticated: Bool { user != nil }
    var storage: Storage?
}
