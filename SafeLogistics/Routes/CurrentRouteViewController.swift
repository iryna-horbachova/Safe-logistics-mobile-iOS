import UIKit
import MapKit

class CurrentRouteViewController: UIViewController {

  var currentRoute: DesignatedRoute!
  let mapView = MKMapView()
  var routeInfoView: CurrentRouteInfoView!
  
  var routeViewIsDisplayed = true
  lazy var routeInfoViewIsVisibleConstraint = routeInfoView.heightAnchor.constraint(equalToConstant: 200)
  lazy var routeInfoViewIsNotVisibleConstraint = routeInfoView.heightAnchor.constraint(equalToConstant: 0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = NSLocalizedString("Current route", comment: "Current route")
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Details", comment: "details"),
                                                        style: .plain, target: self,
                                                        action: #selector(detailsButtonClicked))
    
    
    // Handling maps
    mapView.delegate = self
    var startString =  currentRoute.route.startLocation.components(separatedBy: " ")
    let startLocationLon = Double(startString[1].dropFirst())
    let startLocationLat = Double(startString[2].dropLast())
    
    var endString =  currentRoute.route.startLocation.components(separatedBy: " ")
    let endLocationLon = Double(endString[1].dropFirst())
    let endLocationLat = Double(endString[2].dropLast())
    print(endString)
    print("end")
    print(endLocationLon)
    print(endLocationLat)

    // "SRID=4326;POINT (0.003528804219372761 0.01316783590369009)"
    //let startPointAnnotation = MKPointAnnotation()
    //startPointAnnotation.coordinate = CLLocationCoordinate2D(latitude: 49.993821, longitude: 36.246313)
    let startPointCoordinate = CLLocationCoordinate2D(latitude: startLocationLat!, longitude: startLocationLon!)
    let endPointCoordinate = CLLocationCoordinate2D(latitude: endLocationLat!, longitude: endLocationLon!)
    
    showRouteOnMap(pickupCoordinate: startPointCoordinate, destinationCoordinate: endPointCoordinate)
    //mapView.addAnnotation(startPointAnnotation)
    
    // UI Handling
    mapView.translatesAutoresizingMaskIntoConstraints = false
    routeInfoView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(mapView)
    view.addSubview(routeInfoView)
    
    routeInfoViewIsVisibleConstraint.isActive = true
    NSLayoutConstraint.activate(
      [
        routeInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        routeInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        routeInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        //routeInfoView.heightAnchor.constraint(equalToConstant: 200),
        mapView.topAnchor.constraint(equalTo: view.topAnchor),
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        mapView.bottomAnchor.constraint(equalTo: routeInfoView.topAnchor),
      ]
    )
    
    let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
    swipeUp.direction = .up
    view.addGestureRecognizer(swipeUp)

    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
    swipeDown.direction = .down
    view.addGestureRecognizer(swipeDown)
  }
  
  func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
    
    let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
    let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
    
    let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
    
    let sourceAnnotation = MKPointAnnotation()
    
    if let location = sourcePlacemark.location {
      sourceAnnotation.coordinate = location.coordinate
    }
    
    let destinationAnnotation = MKPointAnnotation()
    
    if let location = destinationPlacemark.location {
      destinationAnnotation.coordinate = location.coordinate
    }
    
    mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
    
    let directionRequest = MKDirections.Request()
    directionRequest.source = sourceMapItem
    directionRequest.destination = destinationMapItem
    directionRequest.transportType = .automobile
    
    // Calculate the direction
    let directions = MKDirections(request: directionRequest)
    
    directions.calculate { (response, error) -> Void in 
      
      guard let response = response else {
        if let error = error {
          print("Error: \(error)")
        }
        
        return
      }
      
      let route = response.routes[0]
      
      self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
      
      let rect = route.polyline.boundingMapRect
      self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
    }
  }
  
  @objc private func handleSwipeGesture(gesture: UISwipeGestureRecognizer) {
    if gesture.direction == .up || gesture.direction == .down {
      handleRouteInfoOnDisplay()
    }
  }
  @objc private func detailsButtonClicked() {
    handleRouteInfoOnDisplay()
  }
  
  private func handleRouteInfoOnDisplay() {
    if routeViewIsDisplayed {
      routeInfoViewIsVisibleConstraint.isActive = false
      routeInfoViewIsNotVisibleConstraint.isActive = true
      routeInfoView.changeRouteStatusButton.isHidden = true
    } else {
      routeInfoViewIsVisibleConstraint.isActive = true
      routeInfoViewIsNotVisibleConstraint.isActive = false
      routeInfoView.changeRouteStatusButton.isHidden = false
    }
    routeViewIsDisplayed = !routeViewIsDisplayed
    UIView.animate(withDuration: 0.5) {
      self.view.layoutIfNeeded()
    }
  }
}

extension CurrentRouteViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
    renderer.lineWidth = 5.0
    return renderer
  }
  
}
