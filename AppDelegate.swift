import UIKit

let primaryColor = UIColor(red:1.00, green:0.96, blue:0.73, alpha:1.0)
let secondaryColor = UIColor(red:0.80, green:0.96, blue:0.92, alpha:1.0)

let beginningText = "Взгляни на это заведение \u{1F37D} "
let adressText = "Оно находится по адресу: "
let linkOfRests = "Открыть в приложении: \n itms-apps://itunes.apple.com/app/id1451515320"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
  var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    UINavigationBar.appearance().barTintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    UINavigationBar.appearance().tintColor = .white
    UITabBar.appearance().tintColor = .white
    UITabBar.appearance().barTintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    return true
  }

 
  func applicationWillTerminate(_ application: UIApplication) {
    self.coreDataStack.saveContext()
  }


}
extension UIApplication {
    var statusBarView : UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

