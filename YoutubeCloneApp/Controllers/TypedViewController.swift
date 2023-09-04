import UIKit

class TypedViewController<View: UIView>: UIViewController where View: RootView {
    var rootView: View { view as! View }

    override func loadView() {
        view = View()
        rootView.initializeUI()
    }
}
