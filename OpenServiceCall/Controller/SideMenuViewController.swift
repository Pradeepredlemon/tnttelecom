
import UIKit
import SJSwiftSideMenuController

class SideMenuViewController: UIViewController {

    var menuItems : NSArray = NSArray()

    // TableView Outlet
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    // Label Outlet
    @IBOutlet weak var labelNameOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let outData = UserDefaults.standard.data(forKey: "USERDATA")
        let dictionaryValues: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        labelNameOutlet.text = (dictionaryValues.value(forKey: "firstname")! as? String)!
    }
    
    @IBAction func buttonSignOutClicked(_ sender: Any) {
        apiLogout()
        UserDefaultsManager.methodForRemoveObjectValue(kIsLoggedIn)
        appDelegate.methodForLogout()
    }
    
    func apiLogout()
    {
        if Reachability.isConnectedToNetwork() == true
        {
            showHud()
            
            let outData = UserDefaults.standard.data(forKey: "USERDATA")
            let dictionaryValues: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
            
            let params = ["user_uuid": (dictionaryValues.value(forKey: "uuid")! as? String)!, "device_type": "ios"]
            
            ServiceManager.POSTServerRequest(klogoutUrl, andParameters: params , success:
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

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        
        cell.labelDataListingOutlet.text = (menuItems[indexPath.row] as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        if UserDefaults.standard.string(forKey: "LOGIN") == "USER" {
            switch indexPath?.row {
            case 0:
                let objHomePageViewController = self.storyboard?.instantiateViewController(withIdentifier:kHomePageViewController) as! HomePageViewController
                AppDelegate.sharedSegmentValue.sharedSegmentStringValue = 1
                SJSwiftSideMenuController.pushViewController(objHomePageViewController, animated: false)
            case 1:
                let objNewTaskViewController = self.storyboard?.instantiateViewController(withIdentifier:kNewTaskViewController) as! NewTaskViewController
                AppDelegate.sharedSegmentValue.sharedSegmentStringValue = 2
                SJSwiftSideMenuController.pushViewController(objNewTaskViewController, animated: false)
            case 2:
                let objHomePageViewController = self.storyboard?.instantiateViewController(withIdentifier:kHomePageViewController) as! HomePageViewController
                AppDelegate.sharedSegmentValue.sharedSegmentStringValue = 2
                SJSwiftSideMenuController.pushViewController(objHomePageViewController, animated: false)
            case 3:
                let objUpdateProfileViewController = self.storyboard?.instantiateViewController(withIdentifier:kUpdateProfileViewController) as! UpdateProfileViewController
                SJSwiftSideMenuController.pushViewController(objUpdateProfileViewController, animated: false)
                case 4:
                    let objEstimatesViewController = self.storyboard?.instantiateViewController(withIdentifier:kEstimatesViewController) as! EstimatesViewController
                    SJSwiftSideMenuController.pushViewController(objEstimatesViewController, animated: false)
            default:
                break
            }
            SJSwiftSideMenuController.hideLeftMenu()
        }
        else
        {
            switch indexPath?.row {
            case 0:
                let objAdminUserListViewController = self.storyboard?.instantiateViewController(withIdentifier:kAdminUserListViewController) as! AdminUserListViewController
                AppDelegate.sharedSegmentValue.sharedSegmentStringValue = 1
                SJSwiftSideMenuController.pushViewController(objAdminUserListViewController, animated: false)
            case 1:
                let objAdminUserListViewController = self.storyboard?.instantiateViewController(withIdentifier: kAdminUserListViewController) as! AdminUserListViewController
                    AppDelegate.sharedSegmentValue.sharedSegmentStringValue = 2
                SJSwiftSideMenuController.pushViewController(objAdminUserListViewController, animated: false)
            case 2:
                let objAdminMapUserListingViewController = self.storyboard?.instantiateViewController(withIdentifier: kAdminMapUserListingViewController) as! AdminMapUserListingViewController
                //              AppDelegate.sharedSegmentValue.sharedSegmentStringValue = 1
                SJSwiftSideMenuController.pushViewController(objAdminMapUserListingViewController, animated: false)
            case 3:
                let objAdminCalendarUserListingViewController = self.storyboard?.instantiateViewController(withIdentifier: kAdminCalendarUserListingViewController) as! AdminCalendarUserListingViewController
                //              AppDelegate.sharedSegmentValue.sharedSegmentStringValue = 1
                SJSwiftSideMenuController.pushViewController(objAdminCalendarUserListingViewController, animated: false)
                
//                let objAdminAddTaskViewController = self.storyboard?.instantiateViewController(withIdentifier: kAdminAddTaskViewController) as! AdminAddTaskViewController
//                //            AppDelegate.sharedSegmentValue.sharedSegmentStringValue = 1
//                SJSwiftSideMenuController.pushViewController(objAdminAddTaskViewController, animated: false)
            default:
                break
            }
            SJSwiftSideMenuController.hideLeftMenu()
        }
    }
    
}
