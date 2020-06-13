
import UIKit
import MessageUI
import MapKit

class NewTaskDetailPageViewController: UIViewController, CLLocationManagerDelegate {
    
    // Button Outlet
    @IBOutlet weak var buttonAcceptOutlet: UIButton!
    @IBOutlet weak var buttonRejectOutlet: UIButton!
    
    // UIView Outlet
    @IBOutlet var viewParentOutlet: UIView!
    
    // TableView Outlet
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var textLabelArray = ["Date", "Time", "Contact Person", "Contact Telephone", "Email", "Address", "Description of Service"] //["Date & Time", "Address", "Contact Person", "Contact Telephone", "Email", "Detail"]
    
    var arr = [String]()
    
    var repositoryDetailPageValue = [Repository]()
    
    var stringLatitude = Double()
    var stringLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonAcceptOutlet.buttonLayout()
        buttonRejectOutlet.buttonLayout()
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewParentOutlet.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customizeNavigationBarWithColoredBar(isVisible: true)
        self.navigationItem.hidesBackButton = false
        
        methodNavigationBarBackGroundAndTitleColor(titleString: "Detail Page")
    }
    
    @IBAction func buttonStatusClicked(_ sender: UIButton) {
        
        guard sender.tag == 1 else {
            
            apiForNewTaskHandler(apiString: kRejectTaskUrl)
            return
        }
        apiForNewTaskHandler(apiString: kAcceptTaskUrl)
    }
    
    func apiForNewTaskHandler(apiString: String)
    {
        let outData = UserDefaults.standard.data(forKey: "USERDATA")
        let dictionaryValues: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary

        if Reachability.isConnectedToNetwork() == true
        {
            showHud()
            let params = ["user_uuid": (dictionaryValues.value(forKey: "uuid")! as? String)!, "task_uuid": repositoryDetailPageValue[0].uuid]
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
                        //                        self.view.makeToast(messageString)
                        appDelegate.methodForUserLogin()
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

extension NewTaskDetailPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textLabelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewTaskDetailPageTableViewCell", for: indexPath) as! NewTaskDetailPageTableViewCell
        
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
    
    @objc func someAction(_ sender: UIButton)  {
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
            
            controller.dismiss(animated: true, completion: nil)
        }

}
