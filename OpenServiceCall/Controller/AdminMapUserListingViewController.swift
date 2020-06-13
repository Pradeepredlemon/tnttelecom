
import UIKit
import GoogleMaps
import Firebase
import CoreLocation
import MapKit

class AdminMapUserListingViewController: UIViewController , GMSMapViewDelegate, CLLocationManagerDelegate {
    
//    var webView: WKWebView!
    var timer: Timer!
    
    var latitudeFloatValue = Double()
    var longitudeFloatValue = Double()
    
    var mapView = GMSMapView()
    
    var titleMarker = String()
    var uuidValue = String()
    
    private var locman = CLLocationManager()
    
    var stringLatitude = Double()
    var stringLongitude = Double()
    
    var markerDict: [String: GMSMarker] = [:]
    
    var states = [State]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightBarButtonClicked()
                        
        //for use in background
        self.locman.requestAlwaysAuthorization()
        
        locman.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locman.location else {
                return
            }
            stringLatitude = currentLocation.coordinate.latitude
            stringLongitude = currentLocation.coordinate.longitude
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
        
        // Create a GMSCameraPosition that tells the map to display the marker
        let camera = GMSCameraPosition.camera(withLatitude: stringLatitude, longitude: stringLongitude , zoom: 5)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        self.view = self.mapView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.refreshEvery3Secs), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    @objc func refreshEvery3Secs() {
        // refresh code
        
        mapView.clear()
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                print(snapshot.key)
                
                guard let latitudeValue = (dictionary["lat"] as? Double) else {
                    return
                }
                self.latitudeFloatValue = latitudeValue
                guard let longitudeValue = (dictionary["long"] as? Double) else {
                    return
                }
                self.longitudeFloatValue = longitudeValue
                guard let titleMarkerValue = (dictionary["username"] as? String) else {
                    return
                }
                self.titleMarker = titleMarkerValue
                guard let uuidValueValue = (dictionary["uuid"] as? String) else {
                    return
                }
                self.uuidValue = uuidValueValue
                if (dictionary["uuid"] as! String) == "3e4537d0-e8dc-11e9-b3a4-ed01f21a3a76" {
                    print("Matched")
                } else if (dictionary["status"] as! Int) != 1  {
                    self.states = [
                        State(name: self.titleMarker, uuid: self.uuidValue, long: self.longitudeFloatValue, lat: self.latitudeFloatValue),
                    ]
                    print("Not Matched")
                }
                
                //                if let latitudeValue = (dictionary["lat"] as? Double)
                //                {
                //                    self.latitudeFloatValue = latitudeValue
                //                    if let longitudeValue = (dictionary["long"] as? Double)
                //                    {
                //                        self.longitudeFloatValue = longitudeValue
                //                        if let titleMarkerValue = (dictionary["username"] as? String)
                //                        {
                //                            self.titleMarker = titleMarkerValue
                //                            if let uuidValueValue = (dictionary["uuid"] as? String)
                //                            {
                //                                self.uuidValue = uuidValueValue
                //                                if (dictionary["uuid"] as! String) == "ed8a4460-340d-11e9-a9cb-cbbe14905c3f" {
                //                                    print("Matched")
                //                                } else if (dictionary["status"] as! Int) != 1  {
                //                                    self.states = [
                //                                        State(name: self.titleMarker, uuid: self.uuidValue, long: self.longitudeFloatValue, lat: self.latitudeFloatValue),
                //                                    ]
                //                                    print("Not Matched")
                //                                }
                //                            }
                //                        }
                //                    }
                //                }
            }
            print(self.states.count)
            for state in self.states {
                // Creates a marker in the center of the map.
                let state_marker = GMSMarker()
                state_marker.position = CLLocationCoordinate2D(latitude: state.lat, longitude: state.long)
                state_marker.icon = UIImage(named: "car")
                state_marker.title = state.name
                state_marker.userData = state.uuid//zIndex = Int32(state.uuid)!
                state_marker.snippet = "Hey, this is \(state.name)"
                state_marker.map = self.mapView
                self.markerDict[state.name] = state_marker
            }
        }, withCancel: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        let objAdminAddTaskViewController = kStoryBoard.instantiateViewController(withIdentifier: kAdminAddTaskViewController) as! AdminAddTaskViewController
        AppDelegate.sharedSegmentValue.sharedUserAssignedValue = 102
        objAdminAddTaskViewController.userAssigned = marker.title!
        objAdminAddTaskViewController.userAssignedId = marker.userData as! String
        navigationController?.pushViewController(objAdminAddTaskViewController, animated: true)
    }
    
}
