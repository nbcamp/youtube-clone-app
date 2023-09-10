import UIKit

protocol RootView: UIView {
    func initializeUI()
}

private enum AssociatedKeys {
    static var viewControllerKey = "ViewControllerKey"
}

extension RootView {
    var viewController: UIViewController? {
        get {
            let weakRef = objc_getAssociatedObject(self, &AssociatedKeys.viewControllerKey) as? WeakRef<UIViewController>
            return weakRef?.value
        }
        set {
            let weakRef = WeakRef(newValue)
            objc_setAssociatedObject(self, &AssociatedKeys.viewControllerKey, weakRef, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
