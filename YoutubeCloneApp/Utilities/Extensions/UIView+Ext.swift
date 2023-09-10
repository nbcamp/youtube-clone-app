import UIKit

extension UIView {
    var name: String { String(describing: type(of: self)) }
}
