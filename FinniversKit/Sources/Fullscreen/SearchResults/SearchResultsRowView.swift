import Foundation

protocol SearchResultsRowViewDelegate: AnyObject {
    func searchResultsRowViewDidSelectButton(_ searchResultsRowView: SearchResultsRowView)
    func searchResultsRowViewDidSelectDeleteButton(_ searchResultsRowView: SearchResultsRowView)
}

class SearchResultsRowView: UIView {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = icon.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .iconColor
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private lazy var button: Button = {
        let button = Button(style: .flat, withAutoLayout: true)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.defaultLow, for: .horizontal)
        button.contentHorizontalAlignment = .leading
        return button
    }()

    private lazy var deleteIconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.tintColor = .iconColor

        let padding: CGFloat = 12
        imageView.image = UIImage(named: .remove)
            .withRenderingMode(.alwaysTemplate)
            .withAlignmentRectInsets(UIEdgeInsets(top: -padding, left: -padding, bottom: -padding, right: -padding))

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteButtonTapped))
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private var icon: UIImage
    private let showDeleteRowIcon: Bool

    weak var delegate: SearchResultsRowViewDelegate?

    init(icon: UIImage, showDeleteRowIcon: Bool) {
        self.icon = icon
        self.showDeleteRowIcon = showDeleteRowIcon
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        fillInSuperview()
        addSubview(stackView)
        stackView.fillInSuperview()

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(button)

        if showDeleteRowIcon {
            stackView.addArrangedSubview(deleteIconImageView)
        }

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            deleteIconImageView.heightAnchor.constraint(equalToConstant: 48),
            deleteIconImageView.widthAnchor.constraint(equalTo: deleteIconImageView.heightAnchor),
        ])
    }

    func configure(with title: String) {
        button.setTitle(title, for: .normal)
    }

    @objc func buttonTapped() {
        delegate?.searchResultsRowViewDidSelectButton(self)
    }

    @objc func deleteButtonTapped() {
        delegate?.searchResultsRowViewDidSelectDeleteButton(self)
    }
}

private extension UIColor {
    class var iconColor: UIColor {
        dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }
}