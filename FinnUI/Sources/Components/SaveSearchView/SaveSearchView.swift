//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public protocol SaveSearchViewDelegate: AnyObject {
    func saveSearchViewTextFieldWillReturn(_ saveSearchView: SaveSearchView)
    func saveSearchView(_ saveSearchView: SaveSearchView, didUpdateIsNotificationCenterOn: Bool)
    func saveSearchView(_ saveSearchView: SaveSearchView, didUpdateIsPushOn: Bool)
    func saveSearchView(_ saveSearchView: SaveSearchView, didUpdateIsEmailOn: Bool)
    func saveSearchViewDidSelectDeleteSearchButton(_ saveSearchView: SaveSearchView)
}

public class SaveSearchView: UIView {
    // MARK: - Public properties

    public weak var delegate: SaveSearchViewDelegate?

    public var isNotificationCenterOn: Bool {
        get { notificationCenterSwitchView.isOn }
        set {
            notificationCenterSwitchView.isOn = newValue
            delegate?.saveSearchView(self, didUpdateIsNotificationCenterOn: newValue)
        }
    }

    public var isPushOn: Bool {
        get { pushSwitchView.isOn }
        set {
            pushSwitchView.isOn = newValue
            delegate?.saveSearchView(self, didUpdateIsPushOn: newValue)
        }
    }

    public var isEmailOn: Bool {
        get { emailSwitchView.isOn }
        set {
            emailSwitchView.isOn = newValue
            delegate?.saveSearchView(self, didUpdateIsEmailOn: newValue)
        }
    }

    public var searchNameText: String? {
        get { searchNameTextField.text }
        set { searchNameTextField.textField.text = newValue }
    }

    // MARK: - Private properties

    private lazy var searchNameContainer: UIView = UIView(withAutoLayout: true)
    private lazy var contentView = UIView(withAutoLayout: true)
    private lazy var notificationCenterSwitchView = createSwitchView()
    private lazy var pushSwitchView = createSwitchView()
    private lazy var emailSwitchView = createSwitchView()
    private var heightConstraint: NSLayoutConstraint!

    private let switchStyle = SwitchViewStyle(
        titleLabelStyle: .bodyStrong,
        titleLabelTextColor: .textPrimary,
        detailLabelStyle: .caption,
        detailLabelTextColor: .textPrimary
    )

    private lazy var searchNameTextField: TextField = {
        let textField = TextField(inputType: .normal)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textField.returnKeyType = .go
        textField.delegate = self
        return textField
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.contentInsetAdjustmentBehavior = .always
        return scrollView
    }()

    private lazy var deleteSavedSearchButton: Button = {
        let button = Button(style: .destructive, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleDeleteButtonTap), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public methods

    public func configure(with viewModel: SaveSearchViewModel) {
        searchNameTextField.textField.text = viewModel.searchTitle
        searchNameTextField.placeholderText = viewModel.searchPlaceholderText

        notificationCenterSwitchView.configure(with: viewModel.notificationCenterSwitchViewModel)
        pushSwitchView.configure(with: viewModel.pushSwitchViewModel)
        emailSwitchView.configure(with: viewModel.emailSwitchViewModel)

        if let deleteSearchButtonTitle = viewModel.deleteSearchButtonTitle {
            deleteSavedSearchButton.isHidden = false
            deleteSavedSearchButton.setTitle(deleteSearchButtonTitle, for: .normal)
        } else {
            deleteSavedSearchButton.isHidden = true
        }
    }

    public func setNotificationCenterOn(_ isOn: Bool, animated: Bool) {
        notificationCenterSwitchView.setOn(isOn, animated: animated)
    }

    public func setPushOn(_ isOn: Bool, animated: Bool) {
        pushSwitchView.setOn(isOn, animated: animated)
    }

    public func setEmailOn(_ isOn: Bool, animated: Bool) {
        emailSwitchView.setOn(isOn, animated: animated)
    }

    @discardableResult public override func becomeFirstResponder() -> Bool {
        searchNameTextField.textField.becomeFirstResponder()
    }

    @discardableResult public override func resignFirstResponder() -> Bool {
        searchNameTextField.textField.resignFirstResponder()
    }

    // MARK: - Private methods

    private func setup() {
        backgroundColor = .bgPrimary

        scrollView.addSubview(contentView)
        addSubview(scrollView)
        scrollView.fillInSuperview()

        searchNameContainer.addSubview(searchNameTextField)

        contentView.addSubview(searchNameContainer)
        contentView.addSubview(stackView)
        contentView.addSubview(deleteSavedSearchButton)

        stackView.addArrangedSubviews([
            notificationCenterSwitchView,
            HairlineView(),
            pushSwitchView,
            HairlineView(),
            emailSwitchView
        ])

        stackView.arrangedSubviews.filter { $0 is HairlineView }.forEach {
            $0.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        }

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: widthAnchor),

            searchNameContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            searchNameContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchNameContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            searchNameContainer.heightAnchor.constraint(equalToConstant: 65.0),

            searchNameTextField.leadingAnchor.constraint(equalTo: searchNameContainer.leadingAnchor, constant: .spacingM),
            searchNameTextField.trailingAnchor.constraint(equalTo: searchNameContainer.trailingAnchor, constant: -.spacingM),
            searchNameTextField.centerYAnchor.constraint(equalTo: searchNameContainer.centerYAnchor),

            stackView.topAnchor.constraint(equalTo: searchNameTextField.bottomAnchor, constant: .spacingM),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            deleteSavedSearchButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .spacingL + .spacingM),
            deleteSavedSearchButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            deleteSavedSearchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            deleteSavedSearchButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil
        )
        notificationCenter.addObserver(
            self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil
        )
    }

    private func createSwitchView() -> SwitchView {
        let view = SwitchView(style: switchStyle, withAutoLayout: true)
        view.delegate = self
        return view
    }

    // MARK: - Actions

    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = scrollView.convert(keyboardScreenEndFrame, from: window)

        let contentSize = contentView.frame.size
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentSize = contentSize
        } else {
            scrollView.contentSize = CGSize(
                width: contentSize.width,
                height: contentSize.height + keyboardViewEndFrame.height
            )
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    @objc private func handleDeleteButtonTap() {
        delegate?.saveSearchViewDidSelectDeleteSearchButton(self)
    }
}

// MARK: - TextFieldDelegate

extension SaveSearchView: TextFieldDelegate {
    public func textFieldShouldReturn(_ textField: TextField) -> Bool {
        delegate?.saveSearchViewTextFieldWillReturn(self)
        return true
    }
}

// MARK: - SwitchViewDelegate

extension SaveSearchView: SwitchViewDelegate {
    public func switchView(_ switchView: SwitchView, didChangeValueFor switch: UISwitch) {
        switch switchView {
        case notificationCenterSwitchView:
            delegate?.saveSearchView(self, didUpdateIsNotificationCenterOn: switchView.isOn)
        case pushSwitchView:
            delegate?.saveSearchView(self, didUpdateIsPushOn: switchView.isOn)
        case emailSwitchView:
            delegate?.saveSearchView(self, didUpdateIsEmailOn: switchView.isOn)
        default:
            break
        }
    }
}

// MARK: - Private types

private class HairlineView: UIView {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let line = UIView(withAutoLayout: true)
        line.backgroundColor = .textDisabled
        addSubview(line)
        line.fillInSuperview(insets: UIEdgeInsets(leading: .spacingM))
    }
}