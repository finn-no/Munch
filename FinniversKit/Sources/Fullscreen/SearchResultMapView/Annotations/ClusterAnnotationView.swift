import MapKit

class ClusterAnnotationView: MKAnnotationView {

    // MARK: - Public properties

    override var annotation: MKAnnotation? {
        didSet { configure() }
    }

    // MARK: - Private properties

    private lazy var annotationView = AnnotationView()

    // MARK: - Init

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(annotationView)

        NSLayoutConstraint.activate([
            annotationView.widthAnchor.constraint(equalToConstant: 32),
            annotationView.heightAnchor.constraint(equalToConstant: 32),
            annotationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            annotationView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Private methods

    private func configure() {
        guard let annotation = annotation as? SearchResultMapViewAnnotation else { return }
        annotationView.configure(with: annotation)
    }
}

// MARK: - Private class

private class AnnotationView: UIView {
    private let hitsLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(hitsLabel)
        hitsLabel.fillInSuperview()
    }

    // MARK: - Public methods

    func configure(with annotation: SearchResultMapViewAnnotation) {
        hitsLabel.text = "\(annotation.hits)"
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        layer.backgroundColor = UIColor.licorice.cgColor
    }
}
