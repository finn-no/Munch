//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class FavoriteAdTableViewCell: UITableViewCell {

    // MARK: - Public properties

    public weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            remoteImageView.dataSource = remoteImageViewDataSource
        }
    }

    public var loadingColor: UIColor?

    // MARK: - Private properties

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var remoteImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var addressLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detail
        label.numberOfLines = 2
        label.textColor = .stone
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textColor = .licorice
        label.numberOfLines = 2
        return label
    }()

    private lazy var descriptionPrimaryLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .bodyStrong
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionSecondaryLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detailStrong
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    private lazy var statusRibbon: RibbonView = {
        let ribbon = RibbonView()
        ribbon.translatesAutoresizingMaskIntoConstraints = false
        return ribbon
    }()

    private var viewModel: FavoriteAdTableViewCellViewModel?
    private let fallbackImage: UIImage = UIImage(named: .noImage)
    private let adImageWidth: CGFloat = 80

    // MARK: - Init

    public override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()

        remoteImageView.cancelLoading()
        remoteImageView.setImage(nil, animated: false)
        [addressLabel, titleLabel, descriptionPrimaryLabel, descriptionSecondaryLabel].forEach {
            $0.text = nil
            $0.isHidden = true
        }
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        let ribbonBackgroundColor = statusRibbon.backgroundColor
        super.setSelected(selected, animated: animated)
        statusRibbon.backgroundColor = ribbonBackgroundColor
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let ribbonBackgroundColor = statusRibbon.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        statusRibbon.backgroundColor = ribbonBackgroundColor
    }

    // MARK: - Setup

    private func setup() {
        setDefaultSelectedBackgound()

        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionPrimaryLabel)
        stackView.addArrangedSubview(descriptionSecondaryLabel)

        if #available(iOS 11.0, *) {
            stackView.setCustomSpacing(.mediumSpacing, after: titleLabel)
        }

        contentView.addSubview(remoteImageView)
        contentView.addSubview(statusRibbon)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            remoteImageView.heightAnchor.constraint(equalToConstant: adImageWidth),
            remoteImageView.widthAnchor.constraint(equalToConstant: adImageWidth),
            remoteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            remoteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),

            statusRibbon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            statusRibbon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .mediumLargeSpacing),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -40),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),

            addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusRibbon.leadingAnchor, constant: -.mediumSpacing)
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: FavoriteAdTableViewCellViewModel) {
        separatorInset = .leadingInset(.mediumLargeSpacing * 2 + adImageWidth)

        self.viewModel = viewModel

        statusRibbon.style = viewModel.ribbonStyle
        statusRibbon.title = viewModel.ribbonTitle

        if let addressText = viewModel.addressText {
            addressLabel.text = addressText
            addressLabel.isHidden = false
        }

        if let titleText = viewModel.titleText {
            titleLabel.text = titleText
            titleLabel.isHidden = false
        }

        if let descriptionPrimaryText = viewModel.descriptionPrimaryText {
            descriptionPrimaryLabel.text = descriptionPrimaryText
            descriptionPrimaryLabel.isHidden = false
        }

        if let descriptionSecondaryText = viewModel.descriptionSecondaryText {
            descriptionSecondaryLabel.text = descriptionSecondaryText
            descriptionSecondaryLabel.isHidden = false
        }
    }

    public func loadImage() {
        guard let viewModel = viewModel, let imagePath = viewModel.imagePath else {
            remoteImageView.setImage(fallbackImage, animated: false)
            return
        }

        remoteImageView.loadImage(for: imagePath, imageWidth: adImageWidth, loadingColor: loadingColor, fallbackImage: fallbackImage)
    }
}
