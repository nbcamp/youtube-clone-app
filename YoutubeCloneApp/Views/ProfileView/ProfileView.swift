import UIKit

final class ProfileView: UIView, RootView {
    weak var user: User? { didSet { observeUserChanged(user: user) } }

    private var isEditMode = false

    private lazy var containerView = {
        let containerView = UIStackView(arrangedSubviews: [
            avatarView,
            nameTextField,
            dividerView,
            emailTextField,
            editButton,
        ])
        containerView.axis = .vertical
        containerView.alignment = .center
        containerView.spacing = 15.0
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dividerView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
        ])
        return containerView
    }()

    private lazy var avatarView = {
        let avatarView = UIView()
        avatarView.tintColor = .systemGray
        avatarView.layer.borderWidth = 5.0
        avatarView.layer.borderColor = UIColor.systemGray.cgColor

        let width: CGFloat = 150
        avatarView.layer.cornerRadius = width / 2
        avatarView.layer.masksToBounds = true
        avatarView.addSubview(avatarImageView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: width),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),

            avatarImageView.topAnchor.constraint(equalTo: avatarView.topAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor),
        ])
        return avatarView
    }()

    private lazy var avatarImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.image = .init(systemName: "photo")
        avatarImageView.transform = .init(scaleX: 0.4, y: 0.4)
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.tintColor = .systemGray
        return avatarImageView
    }()

    private lazy var nameTextField = {
        let nameTextField = UITextField()
        nameTextField.delegate = self
        return nameTextField
    }()

    private lazy var dividerView = {
        let dividerView = UIView()
        dividerView.backgroundColor = .systemGray
        return dividerView
    }()

    private lazy var emailTextField = {
        let emailTextField = UITextField()
        emailTextField.delegate = self
        return emailTextField
    }()

    private lazy var editButton = {
        let editButton = UIButton()
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.label, for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 14)
        editButton.backgroundColor = .systemGray4
        editButton.contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        editButton.layer.cornerRadius = 5.0
        return editButton
    }()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismissKeyboard()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        dismissKeyboard()
    }

    func initializeUI() {
        backgroundColor = .systemBackground
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 40),
            containerView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])

        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarViewTapped)))
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    private func observeUserChanged(user: User?) {
        user?.$avatar.subscribe(by: self, immediate: true) { subscriber, _ in
            guard let avatar = subscriber.user?.uiAvatar else { return }
            DispatchQueue.main.async {
                subscriber.avatarImageView.image = avatar
                subscriber.avatarImageView.transform = .init(scaleX: 1.5, y: 1.5)
            }
        }
        user?.$name.subscribe(by: self, immediate: true) { subscriber, changes in
            subscriber.nameTextField.text = changes.new
        }
        user?.$email.subscribe(by: self, immediate: true) { subscriber, changes in
            subscriber.emailTextField.text = changes.new
        }
    }

    @objc private func avatarViewTapped() {
        guard isEditMode else { return }
        EventBus.shared.emit(
            PickImagesEvent(
                payload: .init(
                    viewController: viewController,
                    selectionLimit: 1,
                    filter: .images
                ) { [weak self] images in
                    self?.avatarImageView.image = images.first
                }
            )
        )
    }

    @objc private func editButtonTapped() {
        isEditMode.toggle()
        editButton.setTitle(isEditMode ? "Done" : "Edit", for: .normal)
        dismissKeyboard()
        if !isEditMode {
            EventBus.shared.emit(
                UpdateUserProfileEvent(
                    payload: .init(
                        avatar: avatarImageView.image,
                        name: nameTextField.text ?? "",
                        email: emailTextField.text ?? ""
                    )
                )
            )
        }
    }

    private func dismissKeyboard() {
        endEditing(true)
    }
}

extension ProfileView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isEditMode
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            user?.$name.publish()
            user?.$email.publish()
            return
        }
    }
}
