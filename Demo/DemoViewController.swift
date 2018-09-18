//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public class DemoViewController<View: UIView>: UIViewController {
    lazy var playgroundView: View = {
        let playgroundView = View(frame: view.frame)
        playgroundView.translatesAutoresizingMaskIntoConstraints = false
        playgroundView.backgroundColor = .milk
        return playgroundView
    }()

    lazy var miniToastView: MiniToastView = {
        let view = MiniToastView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.text = "Double tap to dismiss"
        return view
    }()

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    var hasDismissButton: Bool = false
    var usingDoubleTapToDismiss: Bool = false

    // Normal behaviour
    public init(usingDoubleTapToDismiss: Bool = true) {
        self.usingDoubleTapToDismiss = usingDoubleTapToDismiss
        super.init(nibName: nil, bundle: nil)
    }

    // Instantiate the view controller with a dismiss button
    public init(withDismissButton hasDismissButton: Bool) {
        self.hasDismissButton = hasDismissButton
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(playgroundView)
        view.backgroundColor = .milk

        NSLayoutConstraint.activate([
            playgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playgroundView.topAnchor.constraint(equalTo: view.compatibleTopAnchor),
            playgroundView.bottomAnchor.constraint(equalTo: view.compatibleBottomAnchor),
            ])

        if hasDismissButton {
            let button = Button(style: .callToAction)
            button.setTitle("Dismiss", for: .normal)
            button.addTarget(self, action: #selector(didDoubleTap), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.bottomAnchor.constraint(equalTo: view.compatibleBottomAnchor, constant: -.veryLargeSpacing),
                ])
        } else if usingDoubleTapToDismiss {
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
            doubleTap.numberOfTapsRequired = 2
            view.addGestureRecognizer(doubleTap)
        }

        updateRightBarButtonItem()
    }

    func updateRightBarButtonItem() {
        guard let viewController = self as? DemoViewController<SavedSearchesListViewDemoView> else {
            return
        }

        let isEditing = viewController.playgroundView.savedSearchesListView.isEditing
        let style: UIBarButtonSystemItem = isEditing ? .done : .edit
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: style, target: self, action: #selector(editTapped))
    }

    @objc func didDoubleTap() {
        State.lastSelectedIndexPath = nil
        dismiss(animated: true, completion: nil)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if State.shouldShowDismissInstructions {
            miniToastView.show(in: view)
            State.shouldShowDismissInstructions = false
        }
    }

    @objc func editTapped() {
        guard let viewController = self as? DemoViewController<SavedSearchesListViewDemoView> else {
            return
        }

        let editing = !viewController.playgroundView.savedSearchesListView.isEditing
        viewController.playgroundView.savedSearchesListView.setEditing(editing: editing)
        updateRightBarButtonItem()
    }
}
