import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let templateGaleryVC = ViewController()
        let navigationController = UINavigationController(rootViewController: templateGaleryVC)
        let textAttributes = [NSAttributedStringKey.foregroundColor: Colors.buttonText]
        navigationController.navigationBar.titleTextAttributes = textAttributes
        navigationController.navigationBar.barTintColor = Colors.navBarColor
        navigationController.navigationBar.tintColor = UIColor.orange
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

