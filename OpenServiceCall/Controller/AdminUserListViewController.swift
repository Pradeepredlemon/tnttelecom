
import UIKit

class AdminUserListViewController: UIViewController{
    
    var repositoryTaskList = [Repository]()
    var totalNumberOfItems = Int ()
    var indexValueCount = Int()
    
    // Segment Outlet
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    
    // tableView Outlet
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    // Label Outlet
    @IBOutlet weak var labelNoDataOutlet: UILabel!
    
    // Segment Height-Constraints Outlet
    @IBOutlet weak var heightConstraintsSegmentControlOutlet: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuImage()
        methodNavigationBarBackGroundAndTitleColor(titleString: "Completed Task")
        
        //        apiViewTasks(page: indexValueCount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        indexValueCount = 1
        
        segmentOutlet.font(name: "segoeui", size: 18)
        repositoryTaskList.removeAll()
        
        labelNoDataOutlet.isHidden = true
        self.tableViewOutlet.isHidden = false
        
        guard AppDelegate.sharedSegmentValue.sharedSegmentStringValue == 1 else {
            methodNavigationBarBackGroundAndTitleColor(titleString: "Not Accepted Task")
            
            heightConstraintsSegmentControlOutlet.constant = 0
            segmentOutlet.tintColor = UIColor.clear
            self.view.layoutIfNeeded()
            
            apiNotAcceptedTasks()
            
            //            apiViewTasks(page: indexValueCount, stringTask: "completed")
            return
        }
        
        heightConstraintsSegmentControlOutlet.constant = 50
        segmentOutlet.tintColor = UIColor(red: 0.0/255.0, green: 201.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        self.view.layoutIfNeeded()
        
        let segmentTitle = self.segmentOutlet.titleForSegment(at: self.segmentOutlet.selectedSegmentIndex)
        print(segmentTitle as Any)
        
        if segmentTitle == "PENDING" {
            repositoryTaskList.removeAll()
            print("First Segment Select")
            apiViewTasks(page: indexValueCount, stringTask: "pending")
        }else if segmentTitle == "RUNNING" {
            repositoryTaskList.removeAll()
            print("Second Segment Select")
            apiViewTasks(page: indexValueCount, stringTask: "running")
        }
        else {
            repositoryTaskList.removeAll()
            print("Third Segment Select")
            apiViewTasks(page: indexValueCount, stringTask: "completed")
        }
    }
    
    func apiNotAcceptedTasks()
    {
        repositoryTaskList.removeAll()
        
        if Reachability.isConnectedToNetwork() == true
        {
            showHud()
            
            ServiceManager.methodGETServerRequest(kViewTasksNotifications, success: { response in
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
                    
                    let data = response?["payload"] as? NSDictionary
                    print(data ?? AnyObject.self)
                    let dataValue = data?["data"] as? NSArray
                    print(dataValue ?? AnyObject.self)
                    self.totalNumberOfItems = (data?["total"] as? Int)!
                    
                    guard dataValue?.count == 0 else {
                        self.tableViewOutlet.isHidden = false
                        self.labelNoDataOutlet.isHidden = true
                        
                        for dataCategory in dataValue!
                        {
                            self.repositoryTaskList.append(Repository(getUserList: dataCategory as! NSDictionary))
                        }
                        self.tableViewOutlet.reloadData()
                        print("Data Available")
                        
                        return
                    }
                    print("No Data Available")
                    self.tableViewOutlet.isHidden = true
                    self.labelNoDataOutlet.isHidden = false
                    
                }
            }, failure: {
                error in
                self.hideHUD()
            })
        }
        else{
            self.view.makeToast(kNetworkError)
        }
    }
    
    func apiViewTasks(page: Int, stringTask: String)
    {
        repositoryTaskList.removeAll()
        
        if Reachability.isConnectedToNetwork() == true
        {
            showHud()
            
            ServiceManager.methodGETServerRequest(kViewTasks + "?type=" + stringTask + "&page=" + String(page), success: { response in
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
                    
                    let data = response?["payload"] as? NSDictionary
                    print(data ?? AnyObject.self)
                    let dataValue = data?["data"] as? NSArray
                    print(dataValue ?? AnyObject.self)
                    self.totalNumberOfItems = (data?["total"] as? Int)!
                    
                    
                    guard dataValue?.count == 0 else {
                        self.tableViewOutlet.isHidden = false
                        self.labelNoDataOutlet.isHidden = true
                        
                        for dataCategory in dataValue!
                        {
                            self.repositoryTaskList.append(Repository(getUserList: dataCategory as! NSDictionary))
                        }
                        self.tableViewOutlet.reloadData()
                        print("Data Available")
                        
                        return
                    }
                    print("No DAta Available")
                    self.tableViewOutlet.isHidden = true
                    self.labelNoDataOutlet.isHidden = false
                    
                }
            }, failure: {
                error in
                self.hideHUD()
            })
        }
        else{
            self.view.makeToast(kNetworkError)
        }
    }
    
    @IBAction func buttonSegmentClicked(_ sender: UISegmentedControl) {
        
        indexValueCount = 1
        
        if sender.selectedSegmentIndex == 0 {
            repositoryTaskList.removeAll()
            print("First Segment Select")
            apiViewTasks(page: indexValueCount, stringTask: "pending")
        } else if sender.selectedSegmentIndex == 1 {
            repositoryTaskList.removeAll()
            print("Second Segment Select")
            apiViewTasks(page: indexValueCount, stringTask: "running")
        }
        else{
            repositoryTaskList.removeAll()
            print("Third Segment Select")
            apiViewTasks(page: indexValueCount, stringTask: "completed")
        }
    }
    
}

extension AdminUserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailPageTableViewCell", for: indexPath) as! DetailPageTableViewCell
        
        let dictionaryUserDetail = repositoryTaskList[indexPath.row].userUser
        
        cell.textLabelOutlet.text = repositoryTaskList[indexPath.row].user_title
        
        guard AppDelegate.sharedSegmentValue.sharedSegmentStringValue == 1 else {

            cell.detailTextLabelOutlet.text = "Waiting for technician acceptance..."
            
            return cell
        }
        
        if (dictionaryUserDetail!["firstname"] as? String) != nil && (dictionaryUserDetail!["lastname"] as? String) != nil
        {
            cell.detailTextLabelOutlet.text = "\(String(describing: dictionaryUserDetail!["firstname"] as! String))" + "\(" ")" + "\(String(describing: dictionaryUserDetail!["lastname"] as! String))"
        }
        if (dictionaryUserDetail!["firstname"] as? String) != nil && (dictionaryUserDetail!["lastname"] as? String) == nil
        {
            cell.detailTextLabelOutlet.text = "\(String(describing: dictionaryUserDetail!["firstname"] as! String))" + "\("")"
        }
        if (dictionaryUserDetail!["firstname"] as? String) == nil && (dictionaryUserDetail!["lastname"] as? String) != nil
        {
            cell.detailTextLabelOutlet.text = "\("")" + "\(String(describing: dictionaryUserDetail!["lastname"] as! String))"
        }
        if (dictionaryUserDetail!["firstname"] as? String) == nil && (dictionaryUserDetail!["lastname"] as? String) == nil
        {
            cell.detailTextLabelOutlet.text = "\("")" + "\("")"
        }
        
        let segmentTitle = self.segmentOutlet.titleForSegment(at: self.segmentOutlet.selectedSegmentIndex)
        print(segmentTitle as Any)
        
        if segmentTitle == "PENDING" {
            print("First Segment Select")
            if indexPath.row == repositoryTaskList.count - 1 { // last cell
                if totalNumberOfItems > repositoryTaskList.count { // more items to fetch
                    indexValueCount += 1
                    apiViewTasks(page: indexValueCount, stringTask: "pending") // increment `fromIndex` by 20 before server call
                }
            }
        }else if segmentTitle == "RUNNING" {
            print("Second Segment Select")
            if indexPath.row == repositoryTaskList.count - 1 { // last cell
                if totalNumberOfItems > repositoryTaskList.count { // more items to fetch
                    indexValueCount += 1
                    apiViewTasks(page: indexValueCount, stringTask: "running") // increment `fromIndex` by 20 before server call
                }
            }
        }
        else {
            print("Third Segment Select")
            if indexPath.row == repositoryTaskList.count - 1 { // last cell
                if totalNumberOfItems > repositoryTaskList.count { // more items to fetch
                    indexValueCount += 1
                    apiViewTasks(page: indexValueCount, stringTask: "completed") // increment `fromIndex` by 20 before server call
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objAdminTaskDetailViewController = kStoryBoard.instantiateViewController(withIdentifier: kAdminTaskDetailViewController) as! AdminTaskDetailViewController
        
        let segmentTitle = self.segmentOutlet.titleForSegment(at: self.segmentOutlet.selectedSegmentIndex)
        print(segmentTitle as Any)
        
        objAdminTaskDetailViewController.repositoryTaskDetailData = [repositoryTaskList[indexPath.row]]
        objAdminTaskDetailViewController.stringCheckValue = segmentTitle!
        navigationController?.pushViewController(objAdminTaskDetailViewController, animated: true)
    }
    
}
