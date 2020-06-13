
import UIKit

protocol UserListDelegate {
    func userList(arrayValue: [NSMutableDictionary])
}


class AdminSideUserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // TableView Outlet
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var repositoryTaskList = [Repository]()
    
    var arrayData = [NSMutableDictionary]()
    
    var delegateValue: UserListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Users List"
        
        self.tableViewOutlet.allowsMultipleSelection = true
        self.tableViewOutlet.allowsMultipleSelectionDuringEditing = true
        
        let rightButtonItem = UIBarButtonItem.init( title: "DONE", style: .done, target: self, action: #selector(rightButtonAction))
        rightButtonItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }

    @objc func rightButtonAction()
    {
        delegateValue?.userList(arrayValue: arrayData)
    
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customizeNavigationBarWithColoredBar(isVisible: true)
        self.navigationItem.hidesBackButton = false
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : AdminSideUserListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdminSideUserListTableViewCell", for: indexPath as IndexPath) as! AdminSideUserListTableViewCell
                
        cell.textLabel?.text = repositoryTaskList[indexPath.row].username
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let keyValueData = NSMutableDictionary()
        keyValueData.setValue(repositoryTaskList[indexPath.row].username!, forKey: "UserName")
        keyValueData.setValue(repositoryTaskList[indexPath.row].useruuid!, forKey: "UserUuid")
        arrayData.append(keyValueData) //(repositoryTaskList[indexPath.row].username!)
        
        print(arrayData)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        print(indexPath.row)

        for indexValue in 0..<arrayData.count-1 {

            let arr123 = arrayData[indexValue].value(forKey: "UserName") as? String
            print(arr123 ?? "")
            
            if arrayData[indexValue].value(forKey: "UserName") as? String == repositoryTaskList[indexPath.row].username {
                arrayData.remove(at: indexValue)
            }
        }
        print(arrayData)
    }
    
}
