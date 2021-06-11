import UIKit

protocol ContractVideoLinkViewDelegate: AnyObject {
    func didSelectVideo()
}

class ContractVideoLinkView: UIView {

    weak var delegate: ContractVideoLinkViewDelegate?

    // MARK: - Private properties

    private lazy var playOverlayView = PlayOverlayView(withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var thumbnailImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        setContentHuggingPriority(.required, for: .vertical)
        addSubview(titleLabel)
        addSubview(thumbnailImageView)
        addSubview(playOverlayView)

        [playOverlayView, thumbnailImageView].forEach { view in
            view.isUserInteractionEnabled = true

            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePlayTap))
            view.addGestureRecognizer(gestureRecognizer)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            thumbnailImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            thumbnailImageView.heightAnchor.constraint(
                equalTo: thumbnailImageView.widthAnchor,
                multiplier: 9 / 16
            ),

            playOverlayView.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
            playOverlayView.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor),
            playOverlayView.widthAnchor.constraint(equalToConstant: 40),
            playOverlayView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configure(with videoLink: ContractActionViewModel.VideoLink, remoteImageViewDataSource: RemoteImageViewDataSource) {
        titleLabel.text = videoLink.title
        thumbnailImageView.dataSource = remoteImageViewDataSource
        thumbnailImageView.loadImage(for: videoLink.thumbnailUrl.absoluteString, imageWidth: .zero)
    }

    // MARK: - Actions

    @objc private func handlePlayTap() {
        delegate?.didSelectVideo()
    }
}

private class PlayOverlayView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .playVideo).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: .spacingXL),
            imageView.heightAnchor.constraint(equalToConstant: .spacingXL),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8
    }
}
