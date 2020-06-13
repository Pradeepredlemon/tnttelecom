
import UIKit
import CoreLocation
import MessageUI
import MapKit

class DetailPageViewController: UIViewController, CLLocationManagerDelegate {
    
    static let sharedCheckInValue = DetailPageViewController()
    var sharedCheckInSubValue = String()
    
    @IBOutlet var viewParentOutlet: UIView!
    
    private var locman = CLLocationManager()
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var locManager = CLLocationManager()
    
    var textLabelArray = ["Date", "Time", "Contact Person", "Contact Telephone", "Email", "Address", "Description of Service"]
    
    var buttonStart = UIButton()
    
    // Button Outlet
    @IBOutlet weak var buttonPendingOutlet: UIButton!
    @IBOutlet weak var buttonStartOutlet: UIButton!
    
    // ScrollView Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    
    var repositoryDetailPageValue = [Repository]()
    
    var stringLatitude = Double()
    var stringLongitude = Double()
    
    var arr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for use in background
        self.locman.requestAlwaysAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            stringLatitude = currentLocation.coordinate.latitude
            stringLongitude = currentLocation.coordinate.longitude
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
        
        for i in 0...6 {
            switch i {
            case 0:
                //                let dateString = repositoryDetailPageValue[0].date ?? ""
                //                let timeString = repositoryDetailPageValue[0].time ?? ""
                //                let dateAndTimeString = dateString + " & " + timeString
                
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd"
                let showDate = inputFormatter.date(from: repositoryDetailPageValue[0].date ?? "")
                inputFormatter.dateFormat = "MM-dd-yyyy"
                let resultString = inputFormatter.string(from: showDate!)
                print(resultString)
                
                arr.append(resultString)
            case 1:
                arr.append(repositoryDetailPageValue[0].time ?? "")
            case 2:
                arr.append(repositoryDetailPageValue[0].contact_person!)
            case 3:
                arr.append(repositoryDetailPageValue[0].contact_tel!)
            case 4:
                arr.append(repositoryDetailPageValue[0].contact_email!)
            case 5:
                arr.append(repositoryDetailPageValue[0].address!)
            case 6:
                arr.append(repositoryDetailPageValue[0].issue!)
            default:
                debugPrint("No Data")
            }
            print(arr)
        }
        
        guard AppDelegate.sharedSegmentValue.sharedSegmentStringValue == 1 else {
            return
        }
        
        guard repositoryDetailPageValue[0].task_status! == "pending" else {
            
            buttonStart = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
            buttonStart.titleLabel?.font = UIFont(name: "segoeui", size: 20)
            buttonStart.backgroundColor = UIColor(red: 93.0/255.0, green: 173.0/255.0, blue: 226.0/255.0, alpha: 1.0)
            buttonStart.setTitle("View", for: .normal)
            buttonStart.setTitleColor(UIColor.white, for: .normal)
            self.buttonStart.addTarget(self, action: #selector(self.viewTapped), for: .touchUpInside)
            buttonStart.buttonBorder()
            navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: buttonStart)
            
            return
        }
        buttonStart = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        buttonStart.titleLabel?.font = UIFont(name: "segoeui", size: 20)
        
        if DetailPageViewController.sharedCheckInValue.sharedCheckInSubValue == "CheckInDone" {
            self.buttonStart.backgroundColor = UIColor(red: 93.0/255.0, green: 173.0/255.0, blue: 226.0/255.0, alpha: 1.0)
            self.buttonStart.setTitle("START", for: .normal)
            self.buttonStart.removeTarget(self, action: #selector(self.startTapped), for: .touchUpInside)
            self.buttonStart.addTarget(self, action: #selector(self.stopTapped), for: .touchUpInside)
        }
        else {
            buttonStart.setTitle("Check-In", for: .normal)
            buttonStart.backgroundColor = UIColor.white //UIColor(red: 63.0/255.0, green: 120.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            buttonStart.setTitleColor(UIColor.black, for: .normal)
            buttonStart.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        }
        buttonStart.buttonBorder()
        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: buttonStart)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Upload updated location to server")
        
        let mostRecentLocation = locations.last
        print("Current location: \(NSNumber(value: mostRecentLocation?.coordinate.latitude ?? 0)) \(NSNumber(value: mostRecentLocation?.coordinate.longitude ?? 0))")
        
        let outData = UserDefaults.standard.data(forKey: "USERDATA")
        let dict: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let ref = Constants.refs.databaseChats.child(dict.value(forKey: "uuid") as! String)
        ref.updateChildValues(["latitude": mostRecentLocation?.coordinate.latitude ?? 0, "longitude": mostRecentLocation?.coordinate.longitude ?? 0])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewParentOutlet.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.nameOfFunction), name: NSNotification.Name(rawValue: "nameOfNotificationCancel"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.nameOfFunction), name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)
    }
    
    @objc func nameOfNotificationCancel(notif: NSNotification) {
        
        //Insert code here
        
        viewParentOutlet.isHidden = true
    }
    
    @objc func nameOfFunction(notif: NSNotification) {
        
        //Insert code here
        
        viewParentOutlet.isHidden = true
        
        guard notif.object != nil else {
            return
        }
        
        self.repositoryDetailPageValue.removeAll()
        self.arr.removeAll()
        self.repositoryDetailPageValue.append(Repository(getTaskList: notif.object as! NSDictionary))
        
        for i in 0...6 {
            switch i {
            case 0:
                //                let dateString = repositoryDetailPageValue[0].date ?? ""
                //                let timeString = repositoryDetailPageValue[0].time ?? ""
                //                let dateAndTimeString = dateString + " & " + timeString
                
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd"
                let showDate = inputFormatter.date(from: repositoryDetailPageValue[0].date ?? "")
                inputFormatter.dateFormat = "MM-dd-yyyy"
                let resultString = inputFormatter.string(from: showDate!)
                print(resultString)
                
                arr.append(resultString)
            case 1:
                arr.append(repositoryDetailPageValue[0].time ?? "")
            case 2:
                arr.append(repositoryDetailPageValue[0].contact_person!)
            case 3:
                arr.append(repositoryDetailPageValue[0].contact_tel!)
            case 4:
                arr.append(repositoryDetailPageValue[0].contact_email!)
            case 5:
                arr.append(repositoryDetailPageValue[0].address!)
            case 6:
                arr.append(repositoryDetailPageValue[0].issue!)
            default:
                debugPrint("No Data")
            }
            print(arr)
        }
        
        self.tableViewOutlet.reloadData()
        
    }
    
    @objc func startTapped() {
        print("Start Tapped")
        
        //        let objSpeechToTextViewController = kStoryBoard.instantiateViewController(withIdentifier: "SpeechToTextViewController") as! SpeechToTextViewController
        //        objSpeechToTextViewController.taskUuid = repositoryDetailPageValue[0].uuid!
        //        objSpeechToTextViewController.taskLat = String(stringLatitude)
        //        objSpeechToTextViewController.taskLong = String(stringLongitude)
        //        navigationController?.pushViewController(objSpeechToTextViewController, animated: true)
        
        //        apiStartAndStop(apiString: kStartTask)
        apiCheckIn()
    }
    
    @objc func viewTapped()
    {
        let objSpeechToTextViewController = kStoryBoard.instantiateViewController(withIdentifier: "SpeechToTextViewController") as! SpeechToTextViewController
        objSpeechToTextViewController.taskUuid = self.repositoryDetailPageValue[0].uuid!
        objSpeechToTextViewController.taskLat = String(self.stringLatitude)
        objSpeechToTextViewController.taskLong = String(self.stringLongitude)
        self.navigationController?.pushViewController(objSpeechToTextViewController, animated: true)
        
    }
    
    
    @objc func stopTapped() {
        print("Stop Tapped")
        
        apiStartAndStop(apiString: kStartTask)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customizeNavigationBarWithColoredBar(isVisible: true)
        self.navigationItem.hidesBackButton = false
        
        methodNavigationBarBackGroundAndTitleColor(titleString: "Service Detail")
    }
    
    func apiCheckIn() {
        let outData = UserDefaults.standard.data(forKey: "USERDATA")
        let dictionaryValues: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        if Reachability.isConnectedToNetwork() == true
        {
            showHud()
            let params = ["user_uuid": (dictionaryValues.value(forKey: "uuid")! as? String)! , "task_uuid": repositoryDetailPageValue[0].uuid!] as [String : Any]
            print(params)
            
            ServiceManager.POSTServerRequest(kCheckInUrl, andParameters: params as! [String : String] , success:
                {
                    response in
                    print("response----->",response ?? AnyObject.self)
                    
                    if response is NSDictionary
                    {
                        self.hideHUD()
                        
                        let statusString = response?["success"] as! Bool
                        let messageString = response?["display_msg"] as! String
                        
                        guard statusString == true
                            else
                        {
                            self.view.makeToast(messageString)
                            return
                        }
                        
                        self.view.makeToast("Task notification has been sent to the Admin.")
                        //                            guard apiString == kStartTask else {
                        //                                self.view.makeToast("Your task has been completed.")
                        //                                self.buttonStart.isHidden = true
                        //
                        //                                return
                        //                            }
                        
                        //                            self.view.makeToast("You have started your task. Press done when your task will complete.")
                        
                        
                        DetailPageViewController.sharedCheckInValue.sharedCheckInSubValue = "CheckInDone"
                        
                        self.buttonStart.backgroundColor = UIColor(red: 93.0/255.0, green: 173.0/255.0, blue: 226.0/255.0, alpha: 1.0)
                        self.buttonStart.setTitle("START", for: .normal)
                        self.buttonStart.removeTarget(self, action: #selector(self.startTapped), for: .touchUpInside)
                        self.buttonStart.addTarget(self, action: #selector(self.stopTapped), for: .touchUpInside)
                    }
            }
                ,failure:
                {
                    error in
                    self.hideHUD()
            })
        }
        else {
            self.view.makeToast(kNetworkError)
        }
    }
    
    func apiStartAndStop(apiString: String) {
        let outData = UserDefaults.standard.data(forKey: "USERDATA")
        let dictionaryValues: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        if Reachability.isConnectedToNetwork() == true
        {
            showHud()
            let params = ["user_uuid": (dictionaryValues.value(forKey: "uuid")! as? String)! , "task_uuid": repositoryDetailPageValue[0].uuid!, "lat": String(stringLatitude), "lng": String(stringLongitude)] as [String : Any]
            print(params)
            
            ServiceManager.POSTServerRequest(apiString, andParameters: params as! [String : String] , success:
                {
                    response in
                    print("response----->",response ?? AnyObject.self)
                    
                    if response is NSDictionary
                    {
                        self.hideHUD()
                        
                        let statusString = response?["success"] as! Bool
                        let messageString = response?["display_msg"] as! String
                        
                        guard statusString == true
                            else
                        {
                            self.view.makeToast(messageString)
                            return
                        }
                        
                        guard apiString == kStartTask else {
                            self.view.makeToast("Your task has been completed.")
                            //                            self.buttonStart.isHidden = true
                            //                            self.locman.stopUpdatingLocation()
                            //
                            //                            let ref = Constants.refs.databaseRoot.child("users").child((dictionaryValues.value(forKey: "uuid")! as? String)!)
                            //                            ref.updateChildValues(["status": 0])
                            
                            return
                        }
                        
                        self.locman.delegate = self
                        self.locman.desiredAccuracy = kCLLocationAccuracyBest
                        self.locman.distanceFilter = kCLDistanceFilterNone
                        self.locman.requestAlwaysAuthorization()
                        //                        self.locman.allowsBackgroundLocationUpdates = true
                        self.locman.pausesLocationUpdatesAutomatically = false
                        self.locman.startUpdatingLocation()
                        
                        let objSpeechToTextViewController = kStoryBoard.instantiateViewController(withIdentifier: "SpeechToTextViewController") as! SpeechToTextViewController
                        objSpeechToTextViewController.taskUuid = self.repositoryDetailPageValue[0].uuid!
                        objSpeechToTextViewController.taskLat = String(self.stringLatitude)
                        objSpeechToTextViewController.taskLong = String(self.stringLongitude)
                        DetailPageViewController.sharedCheckInValue.sharedCheckInSubValue = ""
                        self.navigationController?.pushViewController(objSpeechToTextViewController, animated: true)
                        
                        //                        self.view.makeToast("You have started your task. Press done when your task will complete.")
                        //                        self.buttonStart.backgroundColor = UIColor(red: 93.0/255.0, green: 173.0/255.0, blue: 226.0/255.0, alpha: 1.0)
                        //                        self.buttonStart.setTitle("NEXT", for: .normal)
                        //                        self.buttonStart.removeTarget(self, action: #selector(self.startTapped), for: .touchUpInside)
                        //                        self.buttonStart.addTarget(self, action: #selector(self.stopTapped), for: .touchUpInside)
                    }
            }
                ,failure:
                {
                    error in
                    self.hideHUD()
            })
        }
        else {
            self.view.makeToast(kNetworkError)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while requesting new coordinates")
    }
    
    /*   func popUpController()
     {
     let objPopUpViewController = kStoryBoard.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
     
     viewParentOutlet.isHidden = false
     objPopUpViewController.stringTaskUuid = repositoryDetailPageValue[0].uuid!
     objPopUpViewController.stringDetail = repositoryDetailPageValue[0].issue!
     objPopUpViewController.modalPresentationStyle = .overCurrentContext
     objPopUpViewController.modalTransitionStyle = .crossDissolve
     
     self.present(objPopUpViewController, animated: true, completion: nil)
     }   */
    
}

extension DetailPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textLabelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailPageTableViewCell", for: indexPath) as! DetailPageTableViewCell
        
        cell.textLabelOutlet.tag = indexPath.row
        cell.detailTextLabelOutlet.tag = indexPath.row
        
        cell.textLabelOutlet.text = textLabelArray[indexPath.row]
        cell.detailTextLabelOutlet.text = arr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if indexPath.row == 5 {
            let coordinates = CLLocationCoordinate2DMake(Double(repositoryDetailPageValue[0].locationLat!) ?? 0.0, Double(repositoryDetailPageValue[0].locationLng!) ?? 0.0)
            
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
            
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            
            let mapItem = MKMapItem(placemark: placemark)
            
            mapItem.name = repositoryDetailPageValue[0].address!
            
            mapItem.openInMaps(launchOptions:[
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center) ] as [String : Any])
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "CallIcon"), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            button.addTarget(self, action: #selector(self.someAction(_:)), for: .touchUpInside)
            button.tag = indexPath.row
            cell.accessoryView = button
        }
        
        if indexPath.row == 4 {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "MailIcon"), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            button.addTarget(self, action: #selector(self.someAction(_:)), for: .touchUpInside)
            button.tag = indexPath.row
            cell.accessoryView = button
        }
        
        //     if indexPath.row == 10 {
        //     let button = UIButton(type: .custom)
        //     button.setImage(UIImage(named: "EditIcon"), for: .normal)
        //     button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        //     button.addTarget(self, action: #selector(self.someAction(_:)), for: .touchUpInside)
        //     button.tag = indexPath.row
        //     cell.accessoryView = button
        //     }
    }
    
    @objc func someAction(_ sender: UIButton) {
        if sender.tag == 3 {
            let phoneNumber: String = "tel://" + repositoryDetailPageValue[0].contact_tel!
            UIApplication.shared.openURL(URL(string: phoneNumber)!)
        }
        
        if sender.tag == 4 {
            let mailComposeViewController = configureMailComposer()
            if MFMailComposeViewController.canSendMail(){
                self.present(mailComposeViewController, animated: true, completion: nil)
            }else{
                print("Can't send email")
            }
        }
    }
    
    func configureMailComposer() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([repositoryDetailPageValue[0].contact_email!])
        return mailComposeVC
    }
    
//    MARK: - MFMail compose method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue :
            print("Cancelled")
        case MFMailComposeResult.failed.rawValue :
            print("Failed")
        case MFMailComposeResult.saved.rawValue :
            print("Saved")
        case MFMailComposeResult.sent.rawValue :
            print("Sent")
        default: break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
