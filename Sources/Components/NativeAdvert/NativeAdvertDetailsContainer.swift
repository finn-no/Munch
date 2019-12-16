//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

internal final class NativeAdvertDetailsContainer: UIView {

    // MARK: - Private properties

    private var logoSize: CGFloat = 50

    private lazy var container = UIView(withAutoLayout: true)

    private lazy var adRibbonContainer: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.borderWidth = 1
        view.layer.borderColor = .tableViewSeparator
        view.layer.cornerRadius = .smallSpacing
        return view
    }()

    private lazy var adRibbon: UILabel = {
        let view = Label(style: .detail, withAutoLayout: true)
        return view
    }()

    private lazy var companyLabel: UILabel = {
        let view = Label(style: .detail, withAutoLayout: true)
        view.textColor = .textAction
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = Label(style: .body, withAutoLayout: true)
        view.numberOfLines = 3
        return view
    }()

    private lazy var logoView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Constraints

    private lazy var sharedConstraints: [NSLayoutConstraint] = [
        adRibbonContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        adRibbonContainer.topAnchor.constraint(equalTo: container.topAnchor),

        adRibbon.topAnchor.constraint(equalTo: adRibbonContainer.topAnchor, constant: .verySmallSpacing),
        adRibbon.leadingAnchor.constraint(equalTo: adRibbonContainer.leadingAnchor, constant: .smallSpacing),
        adRibbon.bottomAnchor.constraint(equalTo: adRibbonContainer.bottomAnchor, constant: -.verySmallSpacing),
        adRibbon.trailingAnchor.constraint(equalTo: adRibbonContainer.trailingAnchor, constant: -.smallSpacing),

        companyLabel.centerYAnchor.constraint(equalTo: adRibbonContainer.centerYAnchor),
        companyLabel.leadingAnchor.constraint(equalTo: adRibbonContainer.trailingAnchor, constant: .smallSpacing),

        titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        titleLabel.trailingAnchor.constraint(equalTo: logoView.leadingAnchor, constant: -.mediumSpacing),
        titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),

        logoView.widthAnchor.constraint(equalToConstant: logoSize),
        logoView.heightAnchor.constraint(equalToConstant: logoSize),
        logoView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        logoView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
    ]

    private lazy var compactConstraints: [NSLayoutConstraint] = [
        titleLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: .mediumSpacing),
    ]

    private lazy var regularConstraints: [NSLayoutConstraint] = [
        titleLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: .mediumLargeSpacing),
    ]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(container)

        container.fillInSuperview()

        adRibbonContainer.addSubview(adRibbon)

        container.addSubview(adRibbonContainer)
        container.addSubview(companyLabel)
        container.addSubview(titleLabel)
        container.addSubview(logoView)

        NSLayoutConstraint.activate(sharedConstraints)

        setConstraints()
        setFonts()
    }

    func configure(with model: NativeAdvertViewModel, andImageDelegate imageDelegate: NativeAdvertImageDelegate?) {
        if let imageUrl = model.logoImageUrl {
            imageDelegate?.nativeAdvertView(setImageWithURL: imageUrl, onImageView: logoView)
        }

        adRibbon.text = model.ribbonText
        companyLabel.text = model.sponsoredBy
        titleLabel.text = model.title
    }

    // MARK: - Overrides

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setConstraints()
        setFonts()
    }

    private func setConstraints() {
        if traitCollection.horizontalSizeClass == .regular {
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
        } else {
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
        }
    }

    private func setFonts() {
        if traitCollection.horizontalSizeClass == .regular {
            titleLabel.font = .title2
        } else {
            titleLabel.font = .body
        }
    }

}