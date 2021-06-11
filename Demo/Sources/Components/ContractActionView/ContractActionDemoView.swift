import FinniversKit

class ContractActionDemoView: UIView, Tweakable {
    private lazy var contractActionView: ContractActionView = {
        let view = ContractActionView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Plain contract") { [weak self] in
            self?.contractActionView.configure(with: .default)
        },
        TweakingOption(title: "With video link") { [weak self] in
            guard let self = self else { return }
            self.contractActionView.configure(with: .withVideoLink, remoteImageViewDataSource: self)
        }
    ]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(contractActionView)

        NSLayoutConstraint.activate([
            contractActionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            contractActionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            contractActionView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension ContractActionDemoView: ContractActionViewDelegate {
    func contractActionView(_ view: ContractActionView, didSelectActionButtonWithUrl url: URL) {
        print("🔥🔥🔥🔥 \(#function)")
    }

    func contractActionView(_ view: ContractActionView, didSelectVideoWithUrl url: URL) {
        print("🔥🔥🔥🔥 \(#function)")
    }
}

// MARK: - RemoteImageTableViewCellDataSource

extension ContractActionDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - Private extensions

private extension ContractActionViewModel {
    static let `default`: ContractActionViewModel = ContractActionViewModel(
        identifier: "demo-view",
        strings: [
            "Digital signering",
            "Ferdig utfylt kontrakt",
            "1 mnd bilforsikring til kr 0,-"
        ],
        buttonTitle: "Opprett kjøpekontrakt",
        buttonUrl: URL(string: "https://www.finn.no/")!
    )

    static let withVideoLink: ContractActionViewModel = ContractActionViewModel(
        identifier: "demo-view",
        title: "Kjøpekontrakt for bruktbil",
        strings: [
            "Digital signering",
            "Ferdig utfylt kontrakt",
            "1 mnd bilforsikring til kr 0,-"
        ],
        buttonTitle: "Opprett kjøpekontrakt",
        buttonUrl: URL(string: "https://www.finn.no/")!,
        videoLink: ContractActionViewModel.VideoLink(
            title: "Se hvordan smidig bilhandel fungerer",
            videoUrl: URL(string: "https://player.vimeo.com/video/353374268")!,
            thumbnailUrl: URL(string: "https://apps.finn.no/api/image/videothumb/vimeo/529335358")!
        )
    )
}
