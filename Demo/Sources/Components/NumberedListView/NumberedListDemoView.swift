import FinniversKit

class NumberedListDemoView: UIView, Tweakable {

    // MARK: - Private properties

    private let items = NumberedListItem.demoItems
    private lazy var numberedListView = NumberedListView(withAutoLayout: true)
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Items with title and body", action: { [weak self] in
            guard let self = self else { return }
            self.numberedListView.configure(with: self.items)
        }),
        TweakingOption(title: "Items with only body", action: { [weak self] in
            guard let self = self else { return }
            let itemsWithoutBody = self.items.map { NumberedListItem(body: $0.body) }
            self.numberedListView.configure(with: itemsWithoutBody)
        })
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
        directionalLayoutMargins = NSDirectionalEdgeInsets(all: .spacingS)

        addSubview(scrollView)
        scrollView.fillInSuperviewLayoutMargins()
        scrollView.alwaysBounceVertical = true

        scrollView.addSubview(numberedListView)
        numberedListView.fillInSuperview(margin: .spacingM)
        numberedListView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.spacingXL).isActive = true
    }
}

// MARK: - Private extensions

private extension NumberedListItem {
    static var demoItems: [Self] {
        [
            NumberedListItem(
                title: "Leverage agile frameworks",
                body: "Iterative approaches to corporate strategy foster collaborative thinking to further the overall value proposition. Organically grow the holistic world view of disruptive innovation via workplace diversity and empowerment."
            ),
            NumberedListItem(
                title: "Bring win-win survival strategies to the table",
                body: "At the end of the day, going forward, a new normal that has evolved from generation X is on the runway heading towards a streamlined cloud solution. User generated content in real-time will have multiple touchpoints for offshoring."
            ),
            NumberedListItem(
                title: "Capitalize on low hanging fruit",
                body: "Override the digital divide with additional clickthroughs from DevOps. Nanotechnology immersion along the information highway will close the loop on focusing solely on the bottom line."
            ),
            NumberedListItem(
                title: "Use workflows to establish a framework",
                body: "Taking seamless key performance indicators offline to maximise the long tail. Keeping your eye on the ball while performing a deep dive on the start-up mentality to derive convergence on cross-platform integration."
            ),
            NumberedListItem(
                title: "Collaboratively administrate empowered networks",
                body: "Dynamically procrastinate B2C users after installed base benefits. Dramatically visualize customer directed convergence without revolutionary ROI."
            ),
            NumberedListItem(
                title: "Efficiently unleash cross-media information",
                body: "Quickly maximize timely deliverables for real-time schemas. Dramatically maintain clicks-and-mortar solutions without functional solutions."
            )
        ]
    }
}
