//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public protocol VotingViewDelegate: AnyObject {
    func votingView(_ view: VotingView, didSelectVotingButtonWithIdentifier identifier: String)
}

public class VotingView: UIView {

    // MARK: - Public properties

    public weak var delegate: VotingViewDelegate?

    // MARK: - Private properties

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = .spacingS
        return stackView
    }()

    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(stackView)

        NSLayoutConstraint.activate(
        [
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            iconImageView.heightAnchor.constraint(equalToConstant: 48),
            iconImageView.widthAnchor.constraint(equalToConstant: 48),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .spacingS),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXS),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .spacingL),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: VotingViewModel) {
        iconImageView.image = viewModel.icon
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        insertVotingButtons(from: viewModel)
    }

    // MARK: - Private methods

    func insertVotingButtons(from viewModel: VotingViewModel) {
        stackView.removeArrangedSubviews()

        let hairline = HairlineView()
        let leftVotingButton = VotingButtonView(viewModel: viewModel.leftVotingButton, delegate: self)
        let rightVotingButton = VotingButtonView(viewModel: viewModel.rightVotingButton, delegate: self)

        stackView.addArrangedSubviews([
            UIView(withAutoLayout: true),
            leftVotingButton,
            hairline,
            rightVotingButton,
            UIView(withAutoLayout: true)
        ])

        hairline.widthAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
    }
}

// MARK: - VotingButtonViewDelegate

extension VotingView: VotingButtonViewDelegate {
    func votingButtonWasSelected(_ votingButton: VotingButtonView, identifier: String) {
        delegate?.votingView(self, didSelectVotingButtonWithIdentifier: identifier)
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
        line.fillInSuperview()
    }
}
