import UIKit

final class TextFieldGroup: UIStackView {
    var labelText: String? {
        didSet { label.text = labelText }
    }

    var placeholder: String? {
        didSet { textField.placeholder = placeholder }
    }

    var isSecureTextEntry: Bool = false {
        didSet { textField.isSecureTextEntry = isSecureTextEntry }
    }

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    weak var delegate: UITextFieldDelegate? {
        didSet { textField.delegate = delegate }
    }

    private lazy var label = {
        let label = UILabel()
        label.textColor = .secondary
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private lazy var textField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.cornerRadius = 5.0
        textField.borderStyle = .roundedRect
        return textField
    }()

    init() {
        super.init(frame: .zero)
        addArrangedSubview(label)
        addArrangedSubview(textField)
        spacing = 6
        axis = .vertical
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
