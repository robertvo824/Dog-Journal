import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var timer = Timer()
    var time = 0
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var startButton: UIButton!

    @IBOutlet var distance: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var myLocations: [CLLocation] = []
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var startDate: Date!
    var traveledDistance: Double = 0
    
    func processTimer() {
        
        time += 1
        timerLabel.text = String(time)
        
    }
    
    
    
    @IBAction func startMapping(_ sender: Any) {
        
        
        if !timer.isValid {
        
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MapViewController.processTimer), userInfo: nil, repeats: true)
            startButton.setTitle("Stop", for: .normal)
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.distanceFilter = 10
            mapView.userTrackingMode = .follow
            mapView.showsUserLocation = true
            
            self.mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
           
        } else {
            
            timer.invalidate()
            startButton.setTitle("Start", for: .normal)
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
            locationManager.stopMonitoringSignificantLocationChanges()
            locationManager.stopUpdatingLocation()
            
        }
        
        
        
        
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startButton.layer.cornerRadius = 20
        
    }
    
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        myLocations.append(locations[0] as CLLocation)
        let userLocation: CLLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(region, animated: true)
        
        if (myLocations.count > 1){
            var sourceIndex = myLocations.count - 1
            var destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            var polyline = MKPolyline(coordinates: &a, count: a.count)
            mapView.add(polyline)
        }
        
        print(locations.last ?? "none")
        
        if startDate == nil {
            startDate = Date()
        } else {
            print("elapsedTime:", String(format: "%.2fs", Date().timeIntervalSince(startDate)))
        }
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            traveledDistance += lastLocation.distance(from: location)
            print("Distance:",  traveledDistance)
            var distanceToInt = Int(traveledDistance)
            distance.text = String(distanceToInt)
    
        }
        lastLocation = locations.last
    }
        
    }
    
    func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return nil
    }

