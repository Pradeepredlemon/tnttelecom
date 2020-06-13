
import UIKit

class NewTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // TableView Outlet
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    // Label Outlet
    @IBOutlet weak var labelNoDataOutlet: UILabel!
    
    var repositoryTaskList = [Repository]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuImage()
        
        self.title = "New Task"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        repositoryTaskList.removeAll()
        
        labelNoDataOutlet.isHidden = true
        self.tableViewOutlet.isHidden = false

        apiViewTasks()
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : NewTaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewTaskTableViewCell", for: indexPath as IndexPath) as! NewTaskTableViewCell
        //set the data here
        
        cell.buttonViewOutlet.tag = indexPath.row
        cell.buttonViewOutlet.addTarget(self, action: #selector(self.BtnAction(sender:)), for: .touchUpInside)
        
        cell.labelTaskOutlet.text = repositoryTaskList[indexPath.row].title
        
        return cell
    }
    
    @objc func BtnAction(sender:UIButton) {
        let objNewTaskDetailPageViewController = kStoryBoard.instantiateViewController(withIdentifier: kNewTaskDetailPageViewController) as! NewTaskDetailPageViewController
        objNewTaskDetailPageViewController.stringLatitude = Double("0.0")!
        objNewTaskDetailPageViewController.stringLongitude = Double("0.0")!
        objNewTaskDetailPageViewController.repositoryDetailPageValue = [repositoryTaskList[sender.tag]]
        navigationController?.pushViewController(objNewTaskDetailPageViewController, animated: true)
    }
    
    func apiViewTasks()
    {
        let outData = UserDefaults.standard.data(forKey: "USERDATA")
        let dictionaryValues: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary

        if Reachability.isConnectedToNetwork() == true
        {
            showHud()
            let params = ["user_uuid": (dictionaryValues.value(forKey: "uuid")! as? String)!]
            print(params)

            ServiceManager.POSTServerRequest(kNewTaskUrl, andParameters: params , success:
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
