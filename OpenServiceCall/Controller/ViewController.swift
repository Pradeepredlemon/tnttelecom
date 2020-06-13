
import UIKit
import FirebaseAuth
import Firebase
import CoreLocation
import SwiftBackgroundLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

    static let sharedLoginData = ViewController()
    var stringLogin = String()

    var paramsValue = [String: String]()
    
    private var locman = CLLocationManager()

    //View Outlet
    @IBOutlet weak var viewEmailOutlet: UIView!
    @IBOutlet weak var viewPasswordOutlet: UIView!
    
    // Button Outlet
    @IBOutlet weak var buttonLogInOutlet: UIButton!
    @IBOutlet weak var buttonLoginAdminOutlet: UIButton!
    
    // TextField Outlet
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    var appDelagete = {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var backgroundLocations: [CLLocation] = []
    var logger = LocationLogger()
    var locations: [CLLocation] = []
    
    lazy var localizeMeManager: TrackingHeadingLocationManager = {
        return TrackingHeadingLocationManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        textFieldEmail.textFieldPlaceholderColor(textFieldName: "Enter Email...")
//        textFieldPassword.textFieldPlaceholderColor(textFieldName: "Enter Password...")

        viewEmailOutlet.viewCornerRadius()
        viewPasswordOutlet.viewCornerRadius()
        
        buttonLogInOutlet.buttonLayout()
        buttonLoginAdminOutlet.buttonLayout()
        
        self.locman.requestAlwaysAuthorization()
        
        locman.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locman.location else {
                return
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Upload updated location to server")
        
        let mostRecentLocation = locations.last
        print("Current location: \(NSNumber(value: mostRecentLocation?.coordinate.latitude ?? 0)) \(NSNumber(value: mostRecentLocation?.coordinate.longitude ?? 0))")
        
        let outData = UserDefaults.standard.data(forKey: "USERDATA")
        let dict: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let ref = Database.database().reference().child("users").child((dict.value(forKey: "uuid")! as? String)!)
        ref.updateChildValues(["lat": mostRecentLocation?.coordinate.latitude ?? 0, "long": mostRecentLocation?.coordinate.longitude ?? 0])
        
        let refNew = Database.database().reference().child("MapDetails").child((dict.value(forKey: "uuid")! as? String)!)
        refNew.updateChildValues(["latitude": mostRecentLocation?.coordinate.latitude ?? 0, "longitude": mostRecentLocation?.coordinate.longitude ?? 0])
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while requesting new coordinates")
    }

    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
        hideBackButton()
    }
    
    @IBAction func buttonForgotPasswordClicked(_ sender: Any) {
        let objForgotPasswordViewController = kStoryBoard.instantiateViewController(withIdentifier: kForgotPasswordViewController)
       navigationController?.pushViewController(objForgotPasswordViewController, animated: true)
        
        //let objForgotPasswordViewController = kStoryBoard.instantiateViewController(withIdentifier: kAdminAddTaskViewController)
       // navigationController?.pushViewController(objForgotPasswordViewController, animated: true)
    }
    
    @IBAction func buttonLoginClicked(_ sender: Any) {
        apiLogin(loginUrl: kLoginUrl)
        UserDefaults.standard.set("USER", forKey: "LOGIN")
    }
    
    @IBAction func buttonLoginAsAdminClicked(_ sender: Any) {
        apiLogin(loginUrl: kLoginAdminUrl)
        UserDefaults.standard.set("ADMIN", forKey: "LOGIN")
    }
    
    @IBAction func buttonRegisterHereClicked(_ sender: Any) {
        let objRegisterViewController = kStoryBoard.instantiateViewController(withIdentifier: "RegisterViewController")
        navigationController?.pushViewController(objRegisterViewController, animated: true)
    }
    
    private func updateBackgroundLocation(location: CLLocation) {
        backgroundLocations.append(location)
        logger.writeLocationToFile(location: location)
    }
    
    private func updateLocation(location: CLLocation) {
        locations.append(location)
    }
    
    
    func startTracking() {
        appDelagete().backgroundLocationManager.start() { [unowned self] result in
            if case let .Success(location) = result {
                self.updateBackgroundLocation(location: location)
            }
        }
        appDelagete().locationManager.manager(for: .always, completion: { result in
            if case let .Success(manager) = result {
                manager.startUpdatingLocation(isHeadingEnabled: true) { [weak self] result in
                    if case let .Success(locationHeading) = result, let location = locationHeading.location {
                        self?.updateLocation(location: location)
                    }
                }
            }
        })
    }
    
    func apiLogin(loginUrl : String)
    {
        if self.textFieldEmail.text != "" && self.textFieldPassword.text != ""
        {
            if !validateEmail(enteredEmail: textFieldEmail.text!)
            {
                self.view.makeToast(kEmailMessage)
            }
            else
            {
                if Reachability.isConnectedToNetwork() == true
                {
                    showHud()
                    
                   if let notificationString = UserDefaults.standard.string(forKey: "NOTIFICATION")
                   {
                        paramsValue = ["password": self.textFieldPassword.text! , "email": self.textFieldEmail.text!, "device_type": "ios", "device_id": notificationString]
                        print(paramsValue)
                    }
                   else {
                        paramsValue = ["password": self.textFieldPassword.text! , "email": self.textFieldEmail.text!, "device_type": "ios", "device_id": "123456"]
                        print(paramsValue)
                    }
                    
//                    let params = ["password": self.textFieldPassword.text! , "email": self.textFieldEmail.text!, "device_type": "ios", "device_id": notificationString]
                    
                    ServiceManager.POSTServerRequest(loginUrl, andParameters: paramsValue , success:
                        {
                            response in
                            print("response----->",response ?? AnyObject.self)
                            
                            if response is NSDictionary
                            {
                                self.hideHUD()
                                
                                let response123 = response as! NSDictionary
                                let statusString = response123["success"] as! Bool
                                let messageString = response123["display_msg"] as! String
                                
                                guard statusString == true
                                    else
                                {
                                    self.view.makeToast(messageString)
                                    return
                                }
                                
                                let data = response123["payload"] as? NSDictionary
                                print(data ?? AnyObject.self)
                                
                                UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: data!), forKey: "USERDATA")
                                UserDefaultsManager.methodForSaveBooleanValue(true, andKey: kIsLoggedIn)
                                
                                self.locman.delegate = self
                                self.locman.desiredAccuracy = kCLLocationAccuracyBest
                                self.locman.distanceFilter = kCLDistanceFilterNone
                                self.locman.requestAlwaysAuthorization()
//                                self.locman.allowsBackgroundLocationUpdates = true
                                self.locman.pausesLocationUpdatesAutomatically = false
                                self.locman.startUpdatingLocation()

                                BackgroundDebug().print()
                                
                                self.localizeMeManager.stop()
                                self.localizeMeManager.manager(for: .always, completion: { result in
                                    if case let .Success(manager) = result {
                                        manager.startUpdatingLocation(isHeadingEnabled: false) { [weak self] result in
                                            if case let .Success(locationHeading) = result, let location = locationHeading.location {
                                                print("LOCATION--->", location.coordinate.latitude)
                                                
                                                let outData = UserDefaults.standard.data(forKey: "USERDATA")
                                                let dict: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
                                                
                                                let ref = Constants.refs.databaseRoot.child("users").child(dict.value(forKey: "uuid") as! String)
                                                ref.updateChildValues(["lat": location.coordinate.latitude ?? 0, "long": location.coordinate.longitude ?? 0])
                                                
                                                let refNew = Constants.refs.databaseRoot.child("MapDetails").child(dict.value(forKey: "uuid") as! String)
                                                refNew.updateChildValues(["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude])
                                            }
                                        }
                                    }
                                })
                                
                                self.startTracking()

                                appDelegate.methodForUserLogin()
                            }
                    }
                        ,failure:
                        {
                            error in
                            self.hideHUD()
                    })
                } else
                {
                    self.view.makeToast(kNetworkError)
                }
            }
        }
        else
        {
            self.view.makeToast(kRegistrationWarningMessage)
        }
    }
    
}

