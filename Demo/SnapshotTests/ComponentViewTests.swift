//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import XCTest
import FinniversKit
import Demo

class ComponentViewTests: XCTestCase {
    private func snapshot(_ component: ComponentDemoViews, includeIPad: Bool = false, delay: TimeInterval? = nil, testName: String = #function) {
        assertSnapshots(matching: component.viewController, includeDarkMode: true, includeIPad: includeIPad, delay: delay, testName: testName)
    }

    // MARK: - Tests

    func testMissingSnapshotTests() {
        for element in elementWithoutTests(for: ComponentDemoViews.self) {
            XCTFail("Not all elements were implemented, missing: \(element.rawValue)")
        }
    }

    func testAddressCardView() {
        snapshot(.addressCardView)
    }

    func testButton() {
        snapshot(.button)
    }

    func testDialogue() {
        snapshot(.dialogue)
    }

    func testFloatingButton() {
        snapshot(.floatingButton)
    }

    func testCogWheelButton() {
        snapshot(.cogWheelButton)
    }

    func testLabel() {
        snapshot(.label)
    }

    func testRibbon() {
        snapshot(.ribbon)
    }

    func testTextField() {
        snapshot(.textField)
    }

    func testTextView() {
        snapshot(.textView)
    }

    func testToast() {
        snapshot(.toast)
    }

    func testSwitchView() {
        snapshot(.switchView)
    }

    func testInlineConsent() {
        snapshot(.inlineConsent)
    }

    func testInlineConsentV2() {
        snapshot(.inlineConsentV2)
    }

    func testConsentTransparencyInfo() {
        snapshot(.consentTransparencyInfo)
    }

    func testCheckbox() {
        snapshot(.checkbox)
    }

    func testRadioButton() {
        snapshot(.radioButton)
    }

    func testRoundedImageView() {
        snapshot(.roundedImageView)
    }

    func testReviewButtonView() {
        snapshot(.reviewButtonView)
    }

    func testLoadingIndicator() {
        snapshot(.loadingIndicator)
    }

    func testRefreshControl() {
        snapshot(.refreshControl)
    }

    func testHorizontalSlide() {
        snapshot(.horizontalSlide)
    }

    func testBannerTransparencyView() {
        snapshot(.bannerTransparencyView)
    }

    func testBottomSheetMechanics() {
        snapshot(.bottomSheetMechanics)
    }

    func testInfobox() {
        snapshot(.infobox)
    }

    func testFeedbackView() {
        snapshot(.feedbackView)
    }

    func testHappinessRating() {
        snapshot(.happinessRating)
    }

    func testEarthHourView() {
        snapshot(.earthHourView)
    }

    func testStepIndicatorView() {
        snapshot(.stepIndicatorView)
    }

    func testNativeAdvert() {
        snapshot(.nativeAdvert)
    }

    func testCallout() {
        snapshot(.callout)
    }

    func testPhaseList() {
        snapshot(.phaseList)
    }

    func testIconCollection() {
        snapshot(.iconCollection)
    }

    func testDisclaimerView() {
        snapshot(.disclaimerView)
    }

    func testQuestionnaireView() {
      snapshot(.questionnaireView)
    }

    func testTweakable() {
        snapshot(.tweakable)
    }

    func testKlimabroletView() {
        snapshot(.klimabroletView)
    }

    func testSaveSearchPromptView() {
        snapshot(.saveSearchPromptView)
    }

    func testSaveSearchView() {
        snapshot(.saveSearchView)
    }

    func testSearchListEmptyView() {
        snapshot(.searchListEmptyView)
    }

    func testStepSlider() {
        snapshot(.stepSlider)
    }

    func testVerificationView() {
        snapshot(.verificationView)
    }

    func testPanel() {
        snapshot(.panel)
    }

    func testLoanCalculatorView() {
        snapshot(.loanCalculatorView)
    }

    func testVisibilityDrivenTitleView() {
        snapshot(.visibilityDrivenTitleView)
    }

    func testChristmasWishListView() {
        snapshot(.christmasWishListView)
    }

    func testPriming() {
        snapshot(.priming)
    }

    func testSelectorTitleView() {
        snapshot(.selectorTitleView)
    }

    func testFooterButtonView() {
        snapshot(.footerButtonView)
    }

    func testBroadcast() {
        snapshot(.broadcast)
    }

    func testCheckmarkTitleView() {
        snapshot(.checkmarkTitleView)
    }

    func testSelfDeclarationView() {
        snapshot(.selfDeclarationView)
    }

    func testCollapsibleContentView() {
        snapshot(.collapsibleContentView)
    }

    func testViewingsView() {
        snapshot(.viewingsView)
    }

    func testColumnListsView() {
        snapshot(.columnListsView)
    }

    func testKeyValueGridView() {
        snapshot(.keyValueGridView)
    }

    func testObjectPagePriceView() {
        snapshot(.objectPagePriceView)
    }

    func testLinkButtonListView() {
        snapshot(.linkButtonListView)
    }

    func testSafetyElementsView() {
        snapshot(.safetyElementsView, includeIPad: true)
    }

    func testContractActionView() {
        snapshot(.contractActionView)
    }

    func testObjectPageTitleView() {
        snapshot(.objectPageTitleView)
    }

    func testFavoriteButton() {
        snapshot(.favoriteButton)
    }

    func testTransactionProcessSummaryAdManagementView() {
        snapshot(.transactionProcessSummaryAdManagementView)
    }

    func testCoronaHelpView() {
        snapshot(.coronaHelpView)
    }

    func testChatAvailabilityView() {
        snapshot(.chatAvailabilityView)
    }

    func testIconLinkListView() {
        snapshot(.iconLinkListView)
    }

    func testTransactionProcessSummaryObjectPageView() {
        snapshot(.transactionProcessSummaryObjectPageView)
    }

    func testVotingView() {
        snapshot(.votingView)
    }
}
