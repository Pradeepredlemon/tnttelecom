
import UIKit
import FirebaseAuth
import Firebase
import CoreLocation
import SwiftBackgroundLocation

class RegisterViewController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate {
    
    // TextField Outlet
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
//    @IBOutlet weak var textFieldCity: UITextField!
//    @IBOutlet weak var textFieldState: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
//    @IBOutlet weak var textFieldZipcode: UITextField!
    
    // UIView Outlet
    @IBOutlet weak var viewNameOutlet: UIView!
    @IBOutlet weak var viewEmailOutlet: UIView!
    @IBOutlet weak var viewPasswordOutlet: UIView!
    @IBOutlet weak var viewConfirmPasswordOutlet: UIView!
//    @IBOutlet weak var viewCityOutlet: UIView!
//    @IBOutlet weak var viewStateOutlet: UIView!
    @IBOutlet weak var viewPhoneNumberOutlet: UIView!
    @IBOutlet weak var viewLastNameOutlet: UIView!
    @IBOutlet weak var viewAddressOutlet: UIView!
//    @IBOutlet weak var viewZipcodeOutlet: UIView!
    
    // Button Outlet
    @IBOutlet weak var buttonSignUpOutlet: UIButton!
    
    private var locman = CLLocationManager()
    var paramsValue = [String: String]()
    
    var stringLatitude = Double()
    var stringLongitude = Double()
    
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
        viewNameOutlet.viewCornerRadius()
        viewLastNameOutlet.viewCornerRadius()
        viewEmailOutlet.viewCornerRadius()
        viewPasswordOutlet.viewCornerRadius()
        viewConfirmPasswordOutlet.viewCornerRadius()
//        viewCityOutlet.viewCornerRadius()
//        viewStateOutlet.viewCornerRadius()
        viewPhoneNumberOutlet.viewCornerRadius()
        viewAddressOutlet.viewCornerRadius()
//        viewZipcodeOutlet.viewCornerRadius()

//        textFieldName.textFieldPlaceholderColor(textFieldName: "Enter First Name...")
//        textFieldLastName.textFieldPlaceholderColor(textFieldName: "Enter Last Name...")
//        textFieldEmail.textFieldPlaceholderColor(textFieldName: "Enter Email...")
//        textFieldPassword.textFieldPlaceholderColor(textFieldName: "Enter Password...")
//        textFieldConfirmPassword.textFieldPlaceholderColor(textFieldName: "Enter Confirm Password...")
//        textFieldCity.textFieldPlaceholderColor(textFieldName: "Enter City...")
//        textFieldState.textFieldPlaceholderColor(textFieldName: "Enter State...")
//        textFieldPhoneNumber.textFieldPlaceholderColor(textFieldName: "Enter Phone Number...")
//        textFieldAddress.textFieldPlaceholderColor(textFieldName: "Enter Address...")
//        textFieldZipcode.textFieldPlaceholderColor(textFieldName: "Enter Zipcode...")
        
        buttonSignUpOutlet.buttonLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customizeNavigationBar(isVisible: true)
    }
    
    @IBAction func buttonSignUpClicked(_ sender: Any) {
        apiSignUp()
        UserDefaults.standard.set("USER", forKey: "LOGIN")
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while requesting new coordinates")
    }    
    
    func apiSignUp()
    {
        if self.textFieldName.text != "" && self.textFieldEmail.text != "" && self.textFieldPassword.text != "" && self.textFieldConfirmPassword.text != "" && self.textFieldPhoneNumber.text != "" && self.textFieldLastName.text != "" && self.textFieldAddress.text != ""
        {
            if isPasswordSame(password: self.textFieldPassword.text!, confirmPassword: self.textFieldConfirmPassword.text!)
            {
                if validatePhoneNumber(phoneNumber: self.textFieldPhoneNumber.text!)
                {
                    if self.textFieldPhoneNumber.text?.characters.count == 10
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
                                    paramsValue = ["email": self.textFieldEmail.text! , "password": self.textFieldPassword.text!, "firstname": self.textFieldName.text!, "mobile": self.textFieldPhoneNumber.text!, "device_type": "ios", "device_id": notificationString, "lastname": self.textFieldLastName.text!, "address": self.textFieldAddress.text!]
                                    print(paramsValue)
                                }
                                else {
                                    paramsValue = ["email": self.textFieldEmail.text! , "password": self.textFieldPassword.text!, "firstname": self.textFieldName.text!, "mobile": self.textFieldPhoneNumber.text!, "device_type": "ios", "device_id": "123456", "lastname": self.textFieldLastName.text!, "address": self.textFieldAddress.text!]
                                    print(paramsValue)
                                }
                                                                
                                ServiceManager.POSTServerRequest(kRegisterUrl, andParameters: paramsValue , success:
                                    {
                                        response in
                                        print("response----->",response ?? AnyObject.self)
                                        
                                        if response is NSDictionary
                                        {
                                            let response123 = response as! NSDictionary
                                            let statusString = response123["success"] as! Bool
                                            let messageString = response123["display_msg"] as! String
                                            
                                            guard statusString == true
                                                else
                                            {
                                                self.view.makeToast(messageString)
                                                self.hideHUD()
                                                return
                                            }
                                            let data = response123["payload"] as? NSDictionary
                                            print(data ?? AnyObject.self)
                                            
                                            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: data!), forKey: "USERDATA")
                                            UserDefaultsManager.methodForSaveBooleanValue(true, andKey: kIsLoggedIn)
                                            
                                            BackgroundDebug().print()
                                            
                                            self.localizeMeManager.stop()
                                            self.localizeMeManager.manager(for: .always, completion: { result in
                                                if case let .Success(manager) = result {
                                                    manager.startUpdatingLocation(isHeadingEnabled: false) { [weak self] result in
                                                        if case let .Success(locationHeading) = result, let location = locationHeading.location {
                                                            
                                                            let outData = UserDefaults.standard.data(forKey: "USERDATA")
                                                            let dict: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
                                                            
                                                            Database.database().reference().child("users").child((dict.value(forKey: "uuid")! as? String)!).setValue(["username": (dict.value(forKey: "firstname")! as? String)!, "email": (dict.value(forKey: "email")! as? String)!, "uuid": (dict.value(forKey: "uuid")! as? String)!, "lat": self?.stringLatitude as Any, "long": self?.stringLongitude as Any, "status": 0])
                                                            
                                                            let ref = Constants.refs.databaseChats.child(dict.value(forKey: "uuid") as! String)
                                                            let message = ["fromId": dict.value(forKey: "uuid") as! String, "name": dict.value(forKey: "firstname") as! String, "latitude": self?.stringLatitude as Any, "longitude": self?.stringLongitude as Any] as [String : Any]
                                                            ref.setValue(message)
                                                            
//                                                            let reference = Constants.refs.databaseRoot.child("users").child(dict.value(forKey: "uuid") as! String)
//                                                            reference.child("status").setValue(0)//updateChildValues(["status": 1])
                                                            
                                                            let refValueNew = Constants.refs.databaseRoot.child("users").child(dict.value(forKey: "uuid") as! String)
                                                            refValueNew.updateChildValues(["lat": location.coordinate.latitude, "long": location.coordinate.longitude])
                                                            
                                                            let refNew = Constants.refs.databaseRoot.child("MapDetails").child(dict.value(forKey: "uuid") as! String)
                                                            refNew.updateChildValues(["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude])
                                                        }
                                                    }
                                                }
                                            })
                                            
                                            self.startTracking()
                                            
                                            Auth.auth().createUser(withEmail: self.textFieldEmail.text!, password: self.textFieldPassword.text!, completion:
                                                {
                                                    user, error in
                                                    
                                                    print(user as Any)
                                                    self.hideHUD()

                                                    if error != nil {
                                                        print(error as Any)
                                                        
                                                        self.view.makeToast("Something went wrong. Please check again !!!")
                                                    }
                                                    else{
                                                        self.hideHUD()

                                                        print(Auth.auth().currentUser?.uid as Any)
                                                        
                                                        self.locman.delegate = self
                                                        self.locman.desiredAccuracy = kCLLocationAccuracyBest
                                                        self.locman.distanceFilter = kCLDistanceFilterNone
                                                        self.locman.requestAlwaysAuthorization()
//                                                        self.locman.allowsBackgroundLocationUpdates = true
                                                        self.locman.pausesLocationUpdatesAutomatically = false
                                                        self.locman.startUpdatingLocation()
                                                        
                                                        appDelegate.methodForUserLogin()
                                                    }
                                            })
                                        }
                                }
                                    ,failure:
                                    {
                                        error in
                                        self.hideHUD()
                                })
                            }
                            else{
                                self.view.makeToast(kNetworkError)
                            }
                        }
                    }
                    else{
                        self.view.makeToast(kPhoneNumberLengthWaningMessage)
                    }
                }
                else
                {
                    self.view.makeToast(kPhoneNumberWarningMessage)
                }
            }
            else
            {
                self.view.makeToast(kPasswordMatchingWarningMessage)
            }
        }
        else
        {
            self.view.makeToast(kRegistrationWarningMessage)
        }
    }
    
    
}
