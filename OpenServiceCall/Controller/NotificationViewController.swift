
import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // TableView Outlet
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        sideMenuImage()
        methodNavigationBarBackGroundAndTitleColor(titleString: "Completed Task")
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kNotificationTableViewCell, for: indexPath) as! NotificationTableViewCell
        
        cell.labelNotificationDetailOutlet.text = "Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text."
        return cell
    }

}
