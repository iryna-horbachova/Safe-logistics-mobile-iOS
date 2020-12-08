import UIKit

class CurrentRouteInfoView: UIView {

  private var status: String?
  var designatedRoute: DesignatedRoute? {
    didSet {
      status = designatedRoute!.status
      configure()
    }
  }
  private let titleLabel = UILabel.makeTitleLabel()
  private let directionsLabel = UILabel.makeTitleLabel() // Head to the start point || Head to the destination
  private let distanceLabel = UILabel.makeBlackSecondaryLabel()
  private let loadQuantityLabel = UILabel.makeBlackSecondaryLabel()
  public let changeRouteStatusButton = UIButton.makeSecondaryButton(title: "Start route") // Finish route
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    //configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  init(designatedRoute: DesignatedRoute) {
    super.init(frame: .zero)
    self.designatedRoute = designatedRoute
    
    backgroundColor = .systemBackground
    updateView()
    configure()
  }
  
  private func configure() {
    switch status {
    case "N":
      directionsLabel.text = NSLocalizedString("Head to the start point", comment: "Head to the start point")
      changeRouteStatusButton.setTitle(NSLocalizedString("Start route", comment: "Start route"), for: .normal)
      break
    default:
      directionsLabel.text = NSLocalizedString("Head to the destination point", comment: "Head to the destination point")
      changeRouteStatusButton.setTitle(NSLocalizedString("Finish route", comment: "Finish route"), for: .normal)
      break
    }
    titleLabel.text = designatedRoute!.route.title
    distanceLabel.text = NSLocalizedString("Distance", comment: "Distance")
      + ": \(designatedRoute!.route.distance)"
    loadQuantityLabel.text = NSLocalizedString("Load quantity", comment: "Load quantity")
      + ": \(designatedRoute!.route.loadQuantity)"
  }
  
  private func updateView() {
    addSubview(titleLabel)
    addSubview(directionsLabel)
    addSubview(distanceLabel)
    addSubview(loadQuantityLabel)
    addSubview(changeRouteStatusButton)
    
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      directionsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
      directionsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      distanceLabel.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 5),
      distanceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      loadQuantityLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 5),
      loadQuantityLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      
      changeRouteStatusButton.topAnchor.constraint(equalTo: loadQuantityLabel.bottomAnchor, constant: 5),
      changeRouteStatusButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      changeRouteStatusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -60),
    ])
  }

}
