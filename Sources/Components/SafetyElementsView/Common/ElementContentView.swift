//
//  Copyright © 2020 FINN AS. All rights reserved.
//

protocol SafetyElementContentViewDelegate: AnyObject {
    func safetyElementContentView(_ view: SafetyElementsView.ElementContentView, didClickOnLink identifier: String?, url: URL)
}

extension SafetyElementsView {
    class ElementContentView: UIView {
        weak var delegate: SafetyElementContentViewDelegate?

        private var viewModel: SafetyElementViewModel?

        private lazy var contentStackView: UIStackView = {
            let stackView = UIStackView(withAutoLayout: true)
            stackView.axis = .vertical
            stackView.alignment = .leading
            stackView.spacing = .mediumSpacing
            return stackView
        }()

        private let linkButtonStyle = Button.Style.link.overrideStyle(normalFont: .body)

        private lazy var contentLabel: Label = {
            let label = Label(style: .body, withAutoLayout: true)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()

        private lazy var topLinkButton: Button = makeExternalLinkButton(onTap: #selector(didTapOnTopLink))
        private lazy var bottomLinkButton: Button = makeExternalLinkButton(onTap: #selector(didTapOnBottomLink))

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder aDecoder: NSCoder) { fatalError() }

        func configure(with viewModel: SafetyElementViewModel) {
            self.viewModel = viewModel
            contentLabel.text = viewModel.body

            if let topLink = viewModel.topLink {
                topLinkButton.setTitle(topLink.buttonTitle, for: .normal)
                topLinkButton.isHidden = false
            } else {
                topLinkButton.isHidden = true
            }

            if let bottomLink = viewModel.bottomLink {
                bottomLinkButton.setTitle(bottomLink.buttonTitle, for: .normal)
                bottomLinkButton.isHidden = false
            } else {
                bottomLinkButton.isHidden = true
            }
        }

        private func setup() {
            addSubview(contentStackView)

            contentStackView.addArrangedSubview(topLinkButton)
            contentStackView.addArrangedSubview(contentLabel)
            contentStackView.addArrangedSubview(bottomLinkButton)
            contentStackView.fillInSuperviewLayoutMargins()
        }

        @objc private func didTapOnBottomLink() {
            guard let bottomLink = viewModel?.bottomLink else { return }
            didTap(on: bottomLink)
        }

        @objc private func didTapOnTopLink() {
            guard let topLink = viewModel?.topLink else { return }
            didTap(on: topLink)
        }

        private func didTap(on externalLink: LinkButtonViewModel) {
            delegate?.safetyElementContentView(
                self,
                didClickOnLink: externalLink.buttonIdentifier,
                url: externalLink.linkUrl
            )
        }

        private func makeExternalLinkButton(onTap: Selector) -> Button {
            let button = Button(style: linkButtonStyle, withAutoLayout: true)
            button.isHidden = true
            button.contentEdgeInsets = .zero
            button.titleEdgeInsets = .zero
            button.titleLabel?.numberOfLines = 0
            button.contentHorizontalAlignment = .leading
            button.addTarget(self, action: onTap, for: .touchUpInside)
            return button
        }
    }
}