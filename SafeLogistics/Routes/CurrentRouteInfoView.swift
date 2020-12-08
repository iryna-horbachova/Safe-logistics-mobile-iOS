import UIKit

class CurrentRouteInfoView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    //configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  init() {
    super.init(frame: .zero)
    backgroundColor = .red
    //self.status = status
    //self.routeTitle = routeTitle
    //configure()
  }

}
