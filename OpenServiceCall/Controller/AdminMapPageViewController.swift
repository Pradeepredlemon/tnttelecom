
import UIKit
import GoogleMaps
import MapKit
import ARCarMovement
import Firebase
import FirebaseAuth

class AdminMapPageViewController: UIViewController, GMSMapViewDelegate, ARCarMovementDelegate {
    
    var stringUserUuid = String()
    
    var latitudeFloatValue = Double()
    var longitudeFloatValue = Double()
    
    var driverMarker = GMSMarker()
    var mapView = GMSMapView()
    
    var cordinates = [String : Double]()
    var oldCordinates = [String : Double]()
    var newCordinates = [String : Double]()
    var copyCordinates = [String : Double]()
    
    var oldCoordinate: CLLocationCoordinate2D?
    var counter = Int()

    var moveMent = ARCarMovement()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Done")
        
        if counter == 0 {
            showHud()
            counter += 1
        }
        
        print("stringUserUuid--->",stringUserUuid)
        
//        Database.database().reference().child("MapDetails").child(stringUserUuid).observe(.childAdded, with: { (snapshot) in
//            if let dictionary = snapshot.value as? [String: AnyObject]
//            {
//                self.hideHUD()
//
//                self.latitudeFloatValue = (dictionary["latitude"] as! Double)
//                self.longitudeFloatValue = (dictionary["longitude"] as! Double)
//
////                 Create a GMSCameraPosition that tells the map to display the marker
//                let camera = GMSCameraPosition.camera(withLatitude: self.latitudeFloatValue, longitude: self.longitudeFloatValue , zoom: 14)
//                self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//                self.mapView.isMyLocationEnabled = true
//                self.mapView.delegate = self
//                self.view = self.mapView
//
//                // Creates a marker in the center of the map.
//                self.driverMarker = GMSMarker()
//                self.driverMarker.appearAnimation = .pop
//                self.driverMarker.position = CLLocationCoordinate2DMake(self.latitudeFloatValue, self.longitudeFloatValue)
//                self.driverMarker.icon = UIImage(named: "car")
//
//                DispatchQueue.main.async { // Setting marker on mapview in main thread.
//                    self.driverMarker.map = self.mapView
//                }
//            }
//        }, withCancel: nil)
        
        Database.database().reference().child("MapDetails").observe(.childChanged, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                self.hideHUD()
                
                self.latitudeFloatValue = (dictionary["latitude"] as! Double)
                self.longitudeFloatValue = (dictionary["longitude"] as! Double)
                
                self.moveMent.delegate = self
                
                //set old coordinate
                self.oldCoordinate = CLLocationCoordinate2DMake(self.latitudeFloatValue, self.longitudeFloatValue)
                
                // Create a GMSCameraPosition that tells the map to display the marker
                let camera = GMSCameraPosition.camera(withLatitude: self.latitudeFloatValue, longitude: self.longitudeFloatValue , zoom: 14)
                self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                self.mapView.isMyLocationEnabled = true
                self.mapView.delegate = self
                self.view = self.mapView
                
                // Creates a marker in the center of the map.
                self.driverMarker = GMSMarker()
                self.driverMarker.position = self.oldCoordinate!
                self.driverMarker.icon = UIImage(named: "car")
                self.driverMarker.map = self.mapView
                
                self.copyCordinates = self.cordinates

                self.cordinates = ["lattitude":self.latitudeFloatValue,"longitude":self.longitudeFloatValue]
                print("Cordinates_Value",self.cordinates)
                
                if(self.oldCordinates["lattitude"] == nil)
                {
                    self.oldCordinates = self.cordinates
                    self.newCordinates = self.cordinates
                }
                
//                if(self.cordinates["lattitude"] == self.oldCordinates["lattitude"] && self.cordinates["longitude"] == self.oldCordinates["longitude"])
//                {
//                    self.oldCordinates = self.cordinates
//                }
//                else
//                {
                    self.newCordinates = self.cordinates
                    self.oldCordinates = self.copyCordinates
//                }
                
                print("oldCordinates",self.oldCordinates)
                print("newCordinates",self.newCordinates)

                self.movinfMarker()
            }
        }, withCancel: nil)
    }
    
    func updateMarker()
    {
        var marker = GMSMarker()
        
        marker.icon = UIImage(named: "car")
        let position = CLLocationCoordinate2D(latitude: latitudeFloatValue , longitude: longitudeFloatValue)
        marker = GMSMarker(position: position)
        marker.map = mapView
        //marker.iconView = markerView
        mapView.camera = GMSCameraPosition.camera(withTarget: position, zoom: 15)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customizeNavigationBarWithColoredBar(isVisible: true)
        self.navigationItem.hidesBackButton = false
        methodNavigationBarBackGroundAndTitleColor(titleString: "Detail Page")
//        self.mapView.removeFromSuperview()
    }
    
    func ARCarMovementMoved(_ Marker: GMSMarker) {

        driverMarker = Marker
        driverMarker.map = mapView

        //animation to make car icon in center of the mapview

        let updatedCamera = GMSCameraUpdate.setTarget(driverMarker.position, zoom: 15.0)
        mapView.animate(with: updatedCamera)
    }
    
    func updateMapLocation(lattitude:CLLocationDegrees,longitude:CLLocationDegrees){
        let camera = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: 16)
        mapView.camera = camera
        mapView.animate(to: camera)
    }
    
    func movinfMarker(){
        
        driverMarker.map = nil
        
        let oldCoodinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: self.oldCordinates["lattitude"] ?? 0.0 , longitude: self.oldCordinates["longitude"] ?? 0.0)
        let newCoodinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: self.newCordinates["lattitude"] ?? 0.0 , longitude: self.newCordinates["longitude"] ?? 0.0)
        
        print("oldCordinatesNewWala",oldCoodinate as Any)
        print("newCordinatesNewWala",newCoodinate as Any)

        driverMarker.icon = UIImage(named: "car")
        mapView.camera = GMSCameraPosition.camera(withTarget: newCoodinate!, zoom: 17)
        
        driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        //driverMarker.rotation = CLLocationDegrees(getHeadingForDirection(fromCoordinate: oldCoodinate ?? CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0), toCoordinate: newCoodinate ?? CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0)))
        //found bearing value by calculation when marker add
        driverMarker.position = oldCoodinate ?? CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0)
        //this can be old position to make car movement to new position
        driverMarker.map = mapView
        //marker movement animation
        CATransaction.begin()
        CATransaction.setValue(Int(2.0), forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock({() -> Void in
            self.driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            //self.driverMarker.rotation = CDouble(0.5)
            //New bearing value from backend after car movement is done
        })
        driverMarker.position = newCoodinate ?? CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0)
        //this can be new position after car moved from old position to new position with animation
        driverMarker.map = mapView
        driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        // driverMarker.rotation = CLLocationDegrees(getHeadingForDirection(fromCoordinate: oldCoodinate ?? CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0), toCoordinate: newCoodinate ?? CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0)))
        //found bearing value by calculation
        CATransaction.commit()
    }
    
    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        if degree >= 0 {
            return degree
        }
        else {
            return 360 + degree
        }
    }
    
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
