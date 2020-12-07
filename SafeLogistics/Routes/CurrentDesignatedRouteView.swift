import UIKit

class CurrentDesignatedRouteView: UIView {
  
  var status: String? {
    didSet {
      updateView()
    }
  }
  
  var routeTitle: String? {
    didSet {
      updateView()
    }
  }
  
  private let yourRouteLabel = UILabel.makeTitleLabel()
  private let routeTitleLabel = UILabel.makeBlackSecondaryLabel()
  private let statusLabel = UILabel.makeBlackSecondaryLabel()
  public let checkRouteButton = UIButton.makeSecondaryButton(title: "Check route")

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  init(status: String, routeTitle: String?) {
    super.init(frame: .zero)
    self.status = status
    self.routeTitle = routeTitle
    configure()
  }
  
  private func updateView() {
    switch self.status {
    case "N":
      statusLabel.text = NSLocalizedString("Status: Not started", comment: "Status: Not started") 
      break
    case "I":
      statusLabel.text = NSLocalizedString("Status: In progress", comment: "Status: In progress") 
      break
    default:
      yourRouteLabel.text = NSLocalizedString("You don't have any routes at the moment",
                                              comment: "You don't have any routes at the moment") 
      statusLabel.text = NSLocalizedString("Wait for new assignment", comment: "Wait for new assignment") 
      routeTitleLabel.isHidden = true
      checkRouteButton.isHidden = true
      break
    }
    if let routeTitle = routeTitle {
      yourRouteLabel.text = NSLocalizedString("Your current route", comment: "Your current route")
      routeTitleLabel.text = routeTitle
      checkRouteButton.setTitle(NSLocalizedString("Check route", comment: "Check route"), for: .normal)
    }
  }
  
  private func configure() {
    backgroundColor = UIColor(patternImage: UIImage(named: "route")!)
    //backgroundColor = .systemBackground
    addSubview(statusLabel)
    addSubview(routeTitleLabel)
    addSubview(yourRouteLabel)
    addSubview(checkRouteButton)
    
    NSLayoutConstraint.activate([
      yourRouteLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      yourRouteLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
      routeTitleLabel.topAnchor.constraint(equalTo: yourRouteLabel.bottomAnchor, constant: 10),
      routeTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      statusLabel.topAnchor.constraint(equalTo: routeTitleLabel.bottomAnchor, constant: 5),
      statusLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      checkRouteButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5),
      checkRouteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      checkRouteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
    ])
  }
}
