//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ContractActionViewDelegate: AnyObject {
    func contractActionView(_ view: ContractActionView, didSelectActionButtonWithUrl url: URL)
    func contractActionView(_ view: ContractActionView, didSelectVideoWithUrl url: URL)
}

public class ContractActionView: UIView {

    // MARK: - Public properties

    public weak var delegate: ContractActionViewDelegate?
    private(set) var identifier: String?
    private(set) var buttonUrl: URL?
    private(set) var videoUrl: URL?

    // MARK: - Private properties

    private let buttonStyle = Button.Style.default.overrideStyle(borderColor: .btnDisabled)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bulletListLabel, actionButton, videoLinkView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = .spacingL
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var bulletListLabel: Label = {
        let label = Label(withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var actionButton: Button = {
        let button = Button(style: buttonStyle, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var videoLinkView: ContractVideoLinkView = {
        let view = ContractVideoLinkView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgTertiary
        layer.cornerRadius = .spacingS
        layoutMargins = UIEdgeInsets(
            top: .spacingM,
            leading: .spacingM,
            bottom: .spacingL,
            trailing: .spacingM
        )

        addSubview(stackView)
        stackView.fillInSuperviewLayoutMargins()
    }

    // MARK: - Public methods

    public func configure(with viewModel: ContractActionViewModel, remoteImageViewDataSource: RemoteImageViewDataSource? = nil) {
        identifier = viewModel.identifier
        buttonUrl = viewModel.buttonUrl
        videoUrl = viewModel.videoLink?.videoUrl

        bulletListLabel.attributedText = viewModel.strings.bulletPoints(withFont: .body)
        actionButton.setTitle(viewModel.buttonTitle, for: .normal)

        if let title = viewModel.title {
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }

        if let remoteImageViewDataSource = remoteImageViewDataSource, let videoLink = viewModel.videoLink {
            videoLinkView.configure(with: videoLink, remoteImageViewDataSource: remoteImageViewDataSource)
            videoLinkView.isHidden = false
        } else {
            videoLinkView.isHidden = true
        }
    }

    // MARK: - Private methods

    @objc private func handleActionButtonTap() {
        guard let buttonUrl = buttonUrl else { return }
        delegate?.contractActionView(self, didSelectActionButtonWithUrl: buttonUrl)
    }
}

// MARK: - ContractVideoLinkViewDelegate

extension ContractActionView: ContractVideoLinkViewDelegate {
    func didSelectVideo() {
        guard let videoUrl = videoUrl else { return }
        delegate?.contractActionView(self, didSelectVideoWithUrl: videoUrl)
    }
}
