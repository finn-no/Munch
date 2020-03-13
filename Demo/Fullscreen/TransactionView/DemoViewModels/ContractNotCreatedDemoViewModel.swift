//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation.NSString

extension TransactionDemoViewDefaultData {
    static var ContractNotCreatedDemoViewModel = TransactionModel(
        title: "Salgsprosess",

        header: TransactionHeaderModel(
            adId: "171529672",
            title: "BMW i3",
            registrationNumber: "CF40150",
            imagePath: "2020/2/vertical-0/26/2/171/529/672_525135443.jpg"),

        steps: [
            TransactionStepModel(
                state: .completed,
                title: "Annonsen er lagt ut",
                primaryButton: TransactionStepActionButtonModel(
                    text: "Se annonsen",
                    style: "flat",
                    action: "see_ad",
                    fallbackUrl: "www.finn.no/171529672")),

            TransactionStepModel(
                state: .active,
                title: "Kontrakt",
                body: NSAttributedString(string: "Når du har funnet en kjøper er det neste steget å skrive en kontrakt."),
                primaryButton: TransactionStepActionButtonModel(
                    text: "Opprett digital kontrakt",
                    style: "call_to_action",
                    url: "https://www.google.com/search?q=contract+signed")),

            TransactionStepModel(
                state: .notStarted,
                title: "Betaling",
                body: NSAttributedString(string: "Dere kan betale trygt gjennom FINN ved å velge det i kontrakten.")),

            TransactionStepModel(
                state: .notStarted,
                title: "Overlevering",
                body: NSAttributedString(string: "<p>Velger dere å betale gjennom FINN, må overleveringen skje innen 7 dager etter kjøper har betalt.</p><p>Registrering av eierskiftet bør gjøres når dere møtes for overlevering.</p>")),

            TransactionStepModel(
                state: .notStarted,
                title: "Gratulerer med salget!",
                body: NSAttributedString(string: "Du kan finne igjen bilen i Mine kjøretøy under «Eide før»."))
    ])
}
