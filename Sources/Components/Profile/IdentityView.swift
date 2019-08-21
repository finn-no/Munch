//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol IdentityViewModel {
    var profileImage: UIImage { get }
    var displayName: String { get }
    var subtitle: String { get }
    var description: String? { get }

    var isVerified: Bool { get }
    var isTappable: Bool { get }
}

public protocol IdentityViewDelegate: AnyObject {
    func identityViewWasTapped(_ identityView: IdentityView)
}

public class IdentityView : UIView {

    // MARK: - Public properties

    public weak var delegate: IdentityViewDelegate?

    public let viewModel: IdentityViewModel

    // MARK: - UI properties

    private let profileImageSize: CGFloat = 40.0

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: viewModel.profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = profileImageSize / 2
        return imageView
    }()

    private lazy var profileNameLabel: Label = {
        let isTappable = viewModel.isTappable
        let labelStyle: Label.Style = isTappable ? .body: .bodyStrong

        let label = Label(style: labelStyle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = viewModel.displayName

        if isTappable {
            label.textColor = .primaryBlue
        }

        return label
    }()

    private lazy var verifiedBadge: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .verified))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = !viewModel.isVerified
        return imageView
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = viewModel.subtitle
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        if let description = viewModel.description?.trimmingCharacters(in: .whitespacesAndNewlines), !description.isEmpty {
            label.text = description
        } else {
            label.isHidden = true
        }

        return label
    }()

    // MARK: - Setup

    public required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented")
    }

    public required init(viewModel: IdentityViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupSubviews()
        addTapListener()
    }

    private func setupSubviews() {
        layer.cornerRadius = 8
        backgroundColor = .ice

        addSubview(profileImageView)
        addSubview(profileNameLabel)
        addSubview(verifiedBadge)
        addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            profileImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.mediumLargeSpacing),
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageSize),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageSize),

            profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: .mediumSpacing),
            profileNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),

            verifiedBadge.leadingAnchor.constraint(equalTo: profileNameLabel.trailingAnchor, constant: .smallSpacing),
            verifiedBadge.centerYAnchor.constraint(equalTo: profileNameLabel.centerYAnchor),
            verifiedBadge.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumSpacing),
            verifiedBadge.widthAnchor.constraint(equalToConstant: 18),
            verifiedBadge.heightAnchor.constraint(equalToConstant: 18),

            subtitleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: .mediumSpacing),
            subtitleLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: .verySmallSpacing),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])

        if !descriptionLabel.isHidden {
            addSubview(descriptionLabel)
            NSLayoutConstraint.activate([
                descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
                descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: profileImageView.bottomAnchor, constant: .mediumLargeSpacing),
                descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: subtitleLabel.bottomAnchor, constant: .mediumLargeSpacing),
                descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
                descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)
            ])
        }
    }

    private func addTapListener() {
        if viewModel.isTappable {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
            addGestureRecognizer(recognizer)
        }
    }

    // MARK: - Private methods

    @objc private func viewWasTapped() {
        delegate?.identityViewWasTapped(self)
    }
}
