import UIKit

enum ButtonVariant {
    case primary, secondary
}

final class Button: UIButton {
    var variant: ButtonVariant = .primary {
        didSet { configureUI() }
    }

    init(variant: ButtonVariant) {
        super.init(frame: .zero)
        self.variant = variant
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        switch variant {
        case .primary:
            backgroundColor = .primary
            setTitleColor(.white, for: .normal)
        case .secondary:
            backgroundColor = .secondary
            setTitleColor(.white, for: .normal)
        }
    }
}
