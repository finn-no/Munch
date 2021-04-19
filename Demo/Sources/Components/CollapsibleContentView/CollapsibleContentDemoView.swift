//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

class CollapsibleContentDemoView: UIView, Tweakable {

    // MARK: - Private properties

    private var collapsibleContentView: CollapsibleContentView?
    private lazy var contentView = UIView(withAutoLayout: true)
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = .spacingM
        (1...20).forEach({ index in
            let label = Label(style: .body, withAutoLayout: true)
            label.text = "Item \(index)"
            stackView.addArrangedSubview(label)
        })
        return stackView
    }()

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Plain style", action: { [weak self] in
            let overriddenPlainStyle = CollapsibleContentView.Style.plain.withOverride(backgroundColor: .bgTertiary)
            self?.configureCollapsibleContentView(style: overriddenPlainStyle, title: "Spesifikasjoner")
        }),
        TweakingOption(title: "Card style", action: { [weak self] in
            self?.configureCollapsibleContentView(style: .card, title: "6 tips når du skal kjøpe husdyr")
        }),
        TweakingOption(title: "Card style", description: "Long title", action: { [weak self] in
            self?.configureCollapsibleContentView(style: .card, title: "6 tips til deg som skal kjøpe katt, hund eller annet husdyr")
        }),
        TweakingOption(title: "Pet buying tips", action: { [weak self] in
            guard let self = self else { return }
            let style = CollapsibleContentView.Style.card.withOverride(headerContentSpacing: .spacingS)
            let numberedListView = NumberedListView(withAutoLayout: true)
            numberedListView.configure(with: NumberedListItem.demoItems)
            self.configureCollapsibleContentView(
                style: style,
                title: "6 tips når du skal kjøpe husdyr",
                contentView: numberedListView
            )
        }),
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
        contentView.addSubview(stackView)
        stackView.fillInSuperview()

        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.alwaysBounceVertical = true
    }

    private func configureCollapsibleContentView(
        style: CollapsibleContentView.Style,
        title: String,
        contentView: UIView? = nil
    ) {
        collapsibleContentView?.removeFromSuperview()

        let collapsibleContentView = CollapsibleContentView(style: style, withAutoLayout: true)
        collapsibleContentView.configure(with: title, contentView: contentView ?? self.contentView)

        scrollView.addSubview(collapsibleContentView)
        collapsibleContentView.fillInSuperview(margin: .spacingM)
        collapsibleContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -.spacingXL).isActive = true

        self.collapsibleContentView = collapsibleContentView
    }
}

// MARK: - Private extensions

private extension NumberedListItem {
    static var demoItems: [NumberedListItem] {
        [
            NumberedListItem(
                title: "Valget om å skaffe seg hund må være godt gjennomtenkt",
                body: "Husk at hunder lever i mange år, må passes på av noen i feriene og kommer med en del utgifter til f.eks fôr og veterinær."
            ),
            NumberedListItem(
                title: "Velg en hunderase som passer deg og din hverdag",
                body: "Norsk Kennel Klubb kan gi deg nyttige tips til valg av rase."
            ),
            NumberedListItem(
                title: "Kjøp hunden av en seriøs oppdretter",
                body: "Kontakt raseklubben for å få en liste over godkjente oppdrettere. En seriøs oppdretter lar deg besøke valpen og se den sammen med mor og resten av valpekullet. Hos Mattilsynet kan du lese mer om forhåndsregler du bør ta for å ikke kjøpe en ulovlig importert hund."
            ),
            NumberedListItem(
                title: "Sørg for at papirene er i orden",
                body: "Valpen skal ha en nydatert helseattest/ valpeattest og den skal være grunnvaksinert. Hvis hunden er ID-merket, skal du få med bekreftelse på det når du kjøper den. Ikke godta å få dokumentasjon ettersendt!"
            ),
            NumberedListItem(
                title: "Skriv en skikkelig kjøpekontrakt",
                body: "Her må telefonnummer, navn og adresse på oppdretteren komme tydelig frem. Her finner du Forbrukerrådets kontrakt for kjøp av husdyr."
            ),
            NumberedListItem(
                title: "Det er lurt å forsikre hunden",
                body: "Det finnes både veterinærforsikringer og livsforsikringer. Sjekk hos ditt foretrukne forsikringsselskap."
            ),
        ]
    }
}
