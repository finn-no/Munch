//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public protocol CollapsibleContentViewDelegate: AnyObject {
    func collapsibleContentViewDidTapToggleContent(_ view: CollapsibleContentView)
}

public class CollapsibleContentView: UIView {
    // MARK: - Public properties

    /// By default the component will expand the content automatically when tapping on the header
    /// In cases that you want to control that manually by setting `isExpanded`, then you can make
    /// this value to be `false` (defaults `true`)
    public var expandsAutomatically: Bool = true

    public var isEnabled: Bool = true {
        didSet {
            collapseIndicatorImageView.isHidden = !isEnabled
        }
    }

    public var isExpanded: Bool {
        get {
            fullHeightConstraint.isActive
        }
        set {
            newValue ? expandContent() : collapseContent()
        }
    }

    public weak var delegate: CollapsibleContentViewDelegate?

    // MARK: - Private properties

    private let style: Style
    private lazy var innerContainerView = UIView(withAutoLayout: true)
    private lazy var headerView = UIView(withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: style.titleStyle, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var collapseIndicatorImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = indicatorImage
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .iconSecondary
        imageView.isUserInteractionEnabled = true
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    private lazy var fullHeightConstraint: NSLayoutConstraint = {
        let sumOfInsets = style.contentInsets.top + style.contentInsets.bottom
        let constraint = heightAnchor.constraint(equalTo: innerContainerView.heightAnchor, constant: sumOfInsets)
        constraint.priority = .defaultHigh
        return constraint
    }()

    /// When expanding/collapsing the content, ensure the `fullHeightConstraint` is `active` or `inactive` before
    /// getting this image
    private var indicatorImage: UIImage? {
        let assetName: ImageAsset = isExpanded ? .arrowUp : .arrowDown
        return UIImage(named: assetName)
    }

    private lazy var compactHeightConstraint: NSLayoutConstraint = {
        let constraint = heightAnchor.constraint(equalTo: headerView.heightAnchor, constant: style.contentInsets.top * 2)
        constraint.priority = .defaultLow
        return constraint
    }()

    private var contentTopConstraint: NSLayoutConstraint?

    // MARK: - Initializers

    public init(style: Style = .plain, withAutoLayout: Bool) {
        self.style = style
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - UIView overrides

    public override var layoutMargins: UIEdgeInsets {
        didSet {
            contentTopConstraint?.constant = layoutMargins.bottom
        }
    }

    // MARK: - Public methods

    public func configure(with title: String, contentView: UIView, showExpanded: Bool = false) {
        titleLabel.text = title
        addContentView(contentView)
        if showExpanded {
            expandContent()
        }
    }

    // MARK: - Private methods

    private func setup() {
        clipsToBounds = true

        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius

        headerView.addSubview(titleLabel)
        headerView.addSubview(collapseIndicatorImageView)

        innerContainerView.addSubview(headerView)
        addSubview(innerContainerView)

        let contentInsets = style.contentInsets
        NSLayoutConstraint.activate([
            innerContainerView.topAnchor.constraint(equalTo: topAnchor, constant: contentInsets.top),
            innerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.leading),
            innerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.trailing),
            innerContainerView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -contentInsets.bottom),

            headerView.topAnchor.constraint(equalTo: innerContainerView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: innerContainerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: innerContainerView.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),

            collapseIndicatorImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            collapseIndicatorImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .spacingS),
            collapseIndicatorImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            collapseIndicatorImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            compactHeightConstraint,
        ])

        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleContent)))
    }

    private func addContentView(_ contentView: UIView) {
        innerContainerView.addSubview(contentView)

        let offsetFromHeader = style.headerContentSpacing + style.contentInsets.top
        let contentTopConstraint = contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: offsetFromHeader)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            contentTopConstraint,
            contentView.leadingAnchor.constraint(equalTo: innerContainerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: innerContainerView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: innerContainerView.bottomAnchor),
        ])
        self.contentTopConstraint = contentTopConstraint
    }

    @objc private func toggleContent() {
        guard isEnabled else { return }
        guard expandsAutomatically else {
            delegate?.collapsibleContentViewDidTapToggleContent(self)
            return
        }

        fullHeightConstraint.isActive.toggle()
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: { self.superview?.layoutIfNeeded() }
        )

        let newImage = indicatorImage
        UIView.transition(
            with: collapseIndicatorImageView,
            duration: 0.1,
            options: [.transitionCrossDissolve],
            animations: { self.collapseIndicatorImageView.image = newImage }
        )
    }

    private func expandContent() {
        fullHeightConstraint.isActive = true
        collapseIndicatorImageView.image = indicatorImage
    }

    private func collapseContent() {
        fullHeightConstraint.isActive = false
        collapseIndicatorImageView.image = indicatorImage
    }
}

extension CollapsibleContentView {
    public struct Style {
        public let backgroundColor: UIColor
        public let cornerRadius: CGFloat
        public let contentInsets: UIEdgeInsets
        public let titleStyle: Label.Style
        public let headerContentSpacing: CGFloat

        public init(
            backgroundColor: UIColor,
            cornerRadius: CGFloat,
            contentInsets: UIEdgeInsets,
            titleStyle: Label.Style,
            headerContentSpacing: CGFloat
        ) {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.contentInsets = contentInsets
            self.titleStyle = titleStyle
            self.headerContentSpacing = headerContentSpacing
        }

        // MARK: - Defined styles

        public static let plain = Style(
            backgroundColor: .bgPrimary,
            cornerRadius: .zero,
            contentInsets: .init(vertical: .spacingS, horizontal: 0),
            titleStyle: .title3Strong,
            headerContentSpacing: 0
        )

        public static let card = Style(
            backgroundColor: .bgSecondary,
            cornerRadius: 8,
            contentInsets: .init(all: .spacingS),
            titleStyle: .title3Strong,
            headerContentSpacing: 0
        )

        // MARK: - Public methods

        public func withOverride(
            backgroundColor: UIColor? = nil,
            cornerRadius: CGFloat? = nil,
            contentInsets: UIEdgeInsets? = nil,
            titleStyle: Label.Style? = nil,
            headerContentSpacing: CGFloat? = nil
        ) -> CollapsibleContentView.Style {
            CollapsibleContentView.Style(
                backgroundColor: backgroundColor ?? self.backgroundColor,
                cornerRadius: cornerRadius ?? self.cornerRadius,
                contentInsets: contentInsets ?? self.contentInsets,
                titleStyle: titleStyle ?? self.titleStyle,
                headerContentSpacing: headerContentSpacing ?? self.headerContentSpacing
            )
        }
    }
}
