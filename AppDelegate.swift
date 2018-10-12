import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
  var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 0.25)
    
    UINavigationBar.appearance().tintColor = .black
    
    
    UITabBar.appearance().tintColor = .white
    UITabBar.appearance().barTintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 0.79)
//    UITabBar.appearance().selectionIndicatorImage = UIImage(named: "tabSelectBG")
    
    let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
    statusBarView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    self.window?.rootViewController?.view.insertSubview(statusBarView, at: 0)
    
//    if let barFonr = UIFont(name: "Futura-Medium", size: 24)
//    {
//        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: barFonr]
    
        //NSAttributedStringKey.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle as NSString
    //}
    
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
