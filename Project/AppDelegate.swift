import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        let navigationController = UINavigationController()
        let marketViewController = MarketViewController()
        
        navigationController.addChildViewController(marketViewController)
        tabBarController.setViewControllers([navigationController], animated: false)

        return tabBarController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        UIFont.registerTroikaFonts()

        return true
    }
}
