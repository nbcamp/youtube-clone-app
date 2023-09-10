import UIKit

extension UIViewController {
    var name: String { String(describing: type(of: self)) }
}
