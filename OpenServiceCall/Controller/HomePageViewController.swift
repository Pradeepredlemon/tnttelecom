
import UIKit
import CoreLocation
import SwiftBackgroundLocation

class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var stringLatitude = Double()
    var stringLongitude = Double()

    // TableView Outlet
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    // Label Outlet
    @IBOutlet weak var labelNoDataOutlet: UILabel!
    
    // SegmentControl Outlet
    @IBOutlet weak var segmentControlOutlet: UISegmentedControl!
    
    // Segment Height-Constraints Outlet
    @IBOutlet weak var heightConstraintsSegmentControlOutlet: NSLayoutConstraint!
    
    var repositoryTaskList = [Repository]()
    var segmentOutletValue = NSInteger()
    
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
        
        startTracking()
        
        sideMenuImage()
        
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            stringLatitude = currentLocation.coordinate.latitude
            stringLongitude = currentLocation.coordinate.longitude
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        segmentControlOutlet.font(name: "segoeui", size: 18)
        repositoryTaskList.removeAll()
        
        labelNoDataOutlet.isHidden = true
        self.tableViewOutlet.isHidden = false
        
        guard AppDelegate.sharedSegmentValue.sharedSegmentStringValue == 1 else {
            methodNavigationBarBackGroundAndTitleColor(titleString: "Completed Task")
            
            heightConstraintsSegmentControlOutlet.constant = 0
            segmentControlOutlet.tintColor = UIColor.clear
            self.view.layoutIfNeeded()
            
            apiViewTasks(stringTask: "completed")
            return
        }
        methodNavigationBarBackGroundAndTitleColor(titleString: "Home")
        
        heightConstraintsSegmentControlOutlet.constant = 50
        segmentControlOutlet.tintColor = UIColor(red: 0/255.0, green: 201.0/255.0, blue: 241.0/255.0, alpha: 1)
        self.view.layoutIfNeeded()
        
        let segmentTitle = self.segmentControlOutlet.titleForSegment(at: self.segmentControlOutlet.selectedSegmentIndex)
        print(segmentTitle)
        
        if segmentTitle == "PENDING" {
            repositoryTaskList.removeAll()
            print("First Segment Select")
            apiViewTasks(stringTask: "pending")
        }else{
            repositoryTaskList.removeAll()
            print("Second Segment Select")
            apiViewTasks(stringTask: "running")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : HomePageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomePageTableViewCell", for: indexPath as IndexPath) as! HomePageTableViewCell
        //set the data here
        
        cell.buttonViewOutlet.tag = indexPath.row
        cell.buttonViewOutlet.addTarget(self, action: #selector(self.BtnAction(sender:)), for: .touchUpInside)
        
        cell.labelTaskOutlet.text = repositoryTaskList[indexPath.row].title
        
        return cell
    }
    
    @objc func BtnAction(sender:UIButton) {
        let objDetailPageViewController = kStoryBoard.instantiateViewController(withIdentifier: kDetailPageViewController) as! DetailPageViewController
        objDetailPageViewController.stringLatitude = stringLatitude
        objDetailPageViewController.stringLongitude = stringLongitude
//        DetailPageViewController.sharedCheckInValue.sharedCheckInSubValue = "CheckInPending"
        objDetailPageViewController.repositoryDetailPageValue = [repositoryTaskList[sender.tag]]
        navigationController?.pushViewController(objDetailPageViewController, animated: true)
    }
    
    @IBAction func buttonSegmentControlClicked(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            repositoryTaskList.removeAll()
            print("First Segment Select")
            apiViewTasks(stringTask: "pending")
        } else {
            repositoryTaskList.removeAll()
            print("Second Segment Select")
            apiViewTasks(stringTask: "running")
        }
    }
    
    func apiViewTasks(stringTask: String)
    {
        let outData = UserDefaults.standard.data(forKey: "USERDATA")
        let dictionaryValues: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        if Reachability.isConnectedToNetwork() == true
        {
            showHud()
            let params = ["user_uuid": (dictionaryValues.value(forKey: "uuid")! as? String)! , "type": stringTask]
            print(params)
            
            ServiceManager.POSTServerRequest(kNewTasksUrl, andParameters: params , success:
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
//                        self.view.makeToast(messageString)
                        let data = response?["payload"] as? NSArray
                        print(data ?? AnyObject.self)
                        
                        guard data?.count == 0 else {
                            self.tableViewOutlet.isHidden = false
                            self.labelNoDataOutlet.isHidden = true
                            
                            for dataCategory in data!
                            {
                                self.repositoryTaskList.append(Repository(getTaskList: dataCategory as! NSDictionary))
                            }
                            self.tableViewOutlet.reloadData()
                            print("Data Available")
                            
                            return
                        }
                        print("No DAta Available")
                        self.tableViewOutlet.isHidden = true
                        self.labelNoDataOutlet.isHidden = false
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
