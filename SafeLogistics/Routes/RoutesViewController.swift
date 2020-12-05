import UIKit

class RoutesViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Routes"
    
    APIManager.shared.getDriversArray { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let drivers):
        print(drivers)
      case .failure(let error):
        print("error")
        print(error)
      }
    }
  }
  
}
