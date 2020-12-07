import UIKit
import MapKit

class CurrentRouteViewController: UIViewController {

  let mapView = MKMapView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = NSLocalizedString("Current route", comment: "Current route")
    
    mapView.delegate = self
    mapView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(mapView)
    
    //let startPointAnnotation = MKPointAnnotation()
    //startPointAnnotation.coordinate = CLLocationCoordinate2D(latitude: 49.993821, longitude: 36.246313)
    let startPointCoordinate = CLLocationCoordinate2D(latitude: 49.993821, longitude: 36.246313)
    let endPointCoordinate = CLLocationCoordinate2D(latitude: 48.993821, longitude: 35.246313)
    
    showRouteOnMap(pickupCoordinate: startPointCoordinate, destinationCoordinate: endPointCoordinate)
    //mapView.addAnnotation(startPointAnnotation)
    
    NSLayoutConstraint.activate(
      [
        mapView.topAnchor.constraint(equalTo: view.topAnchor),
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ]
    )
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
    
    self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
    
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
}

extension CurrentRouteViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
    renderer.lineWidth = 5.0
    return renderer
  }
  
}
