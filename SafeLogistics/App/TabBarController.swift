import UIKit

class TabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let routesVC = RoutesViewController()
    routesVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Routes", comment: "Routess"),
                                       image: UIImage(named: "routes"),
                                       selectedImage: UIImage(named: "routes"))
    
    let profileVC = ProfileViewController()
    profileVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: "Profile"),
                                        image: UIImage(named: "profile"),
                                        selectedImage: UIImage(named: "profile"))
    
    let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
    UINavigationBar.appearance().titleTextAttributes = attributes
    UINavigationBar.appearance().tintColor = .black
    
    viewControllers = [routesVC, profileVC].map {
      UINavigationController(rootViewController: $0)
    }
  }
}
