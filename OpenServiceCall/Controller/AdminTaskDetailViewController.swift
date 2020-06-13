
import UIKit
import SDWebImage

class AdminTaskDetailViewController: UIViewController {
    
    var repositoryTaskDetailData = [Repository]()
    var stringCheckValue = String()
    
    // Layout Constraints
    @IBOutlet weak var heightLayoutConstraintsOutlet: NSLayoutConstraint!
    @IBOutlet weak var heightLayoutConstraintsSubmissionLabelOutlet: NSLayoutConstraint!
    @IBOutlet weak var heightLayoutConstraintsStackViewOutlet: NSLayoutConstraint!
    @IBOutlet weak var heightLayoutConstraintsViewDescriptionOutlet: NSLayoutConstraint!
    @IBOutlet weak var heightLayoutConstraintsViewSpeechToTextOutlet: NSLayoutConstraint!

    // Button Outlet
    @IBOutlet weak var ButtonMapViewOutlet: UIButton!
    
    // Label Outlet
    @IBOutlet weak var labelTaskIdOutlet: UILabel!
    @IBOutlet weak var labelPersonNameOutlet: UILabel!
    @IBOutlet weak var labelEmailOutlet: UILabel!
    @IBOutlet weak var labelContactNumberOutlet: UILabel!
    @IBOutlet weak var labelDetailOutlet: UILabel!
    @IBOutlet weak var labelPersonNameSubmissionOutlet: UILabel!
    @IBOutlet weak var labelPersonEmailSubmissionOutlet: UILabel!
    @IBOutlet weak var labelContactNumberSubmissionOutlet: UILabel!
    @IBOutlet weak var labelDescriptionSubmissionOutlet: UILabel!
    @IBOutlet weak var labelSpeechToTextOutlet: UILabel!
    @IBOutlet weak var labelDateTimeOutlet: UILabel!
    
    // UIView Outlet
    @IBOutlet weak var viewParentOutlet: UIView!
    @IBOutlet weak var viewparentOutlet1: UIView!
    @IBOutlet weak var viewParentOutlet2: UIView!
    
    // ScrollView Outlet
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    
    // StackView Outlet
    @IBOutlet weak var stackViewOutlet: UIStackView!
    
    // ImageView Outlet
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.labelTaskIdOutlet.text = String(repositoryTaskDetailData[0].user_Id!)
        self.labelPersonNameOutlet.text = repositoryTaskDetailData[0].user_contact_person!
        self.labelEmailOutlet.text = repositoryTaskDetailData[0].user_contact_email!
        self.labelContactNumberOutlet.text = repositoryTaskDetailData[0].user_contact_tel!
        self.labelDetailOutlet.text = repositoryTaskDetailData[0].user_issue!

        if stringCheckValue == "PENDING" {
            ButtonMapViewOutlet.isHidden = true
            
            heightLayoutConstraintsOutlet.constant = 0
            heightLayoutConstraintsSubmissionLabelOutlet.constant = 0
            heightLayoutConstraintsStackViewOutlet.constant = 0
            heightLayoutConstraintsViewDescriptionOutlet.constant = 0
            heightLayoutConstraintsViewSpeechToTextOutlet.constant = 0

            scrollViewOutlet.isScrollEnabled = false

            self.view.layoutIfNeeded()
        }
        
        if stringCheckValue == "RUNNING" {
            
            heightLayoutConstraintsOutlet.constant = 0
            heightLayoutConstraintsSubmissionLabelOutlet.constant = 0
            heightLayoutConstraintsStackViewOutlet.constant = 0
            heightLayoutConstraintsViewDescriptionOutlet.constant = 0
            heightLayoutConstraintsViewSpeechToTextOutlet.constant = 0
            
            self.view.layoutIfNeeded()

            scrollViewOutlet.isScrollEnabled = false

            ButtonMapViewOutlet.setTitle("Map View", for: .normal)
            ButtonMapViewOutlet.isHidden = true   // Make ButtonMapViewOutlet.isHidden = false, when we want to display the MapView at admin running side.
            ButtonMapViewOutlet.buttonLayout()
            
//            let userId = repositoryTaskDetailData[0].userUser!
//            let urlValue = "http://rlhosting.co.in/tnt/public/uploads/signatures/"
//            if (userId["signature"] as! String) != nil {
//                self.imageViewOutlet.sd_setImage(with: URL(string: "\(urlValue)\(userId["signature"] as! String)"), placeholderImage: nil)
//            }
        }
        
        if stringCheckValue == "COMPLETED" {
            
            heightLayoutConstraintsOutlet.constant = 150
            heightLayoutConstraintsSubmissionLabelOutlet.constant = 30
            heightLayoutConstraintsStackViewOutlet.constant = 250
            heightLayoutConstraintsViewDescriptionOutlet.constant = 52
            heightLayoutConstraintsViewSpeechToTextOutlet.constant = 52

            self.view.layoutIfNeeded()

            scrollViewOutlet.isScrollEnabled = true
            
            ButtonMapViewOutlet.setTitle("Invoice", for: .normal)
            ButtonMapViewOutlet.isHidden = false
            ButtonMapViewOutlet.buttonLayout()
            
            let userId = repositoryTaskDetailData[0].task_process!
            let urlValue = "http://rlhosting.co.in/tnt/public/uploads/signatures/"
            if (userId["signature"] as! String) != nil {
                self.imageViewOutlet.sd_setImage(with: URL(string: "\(urlValue)\(userId["signature"] as! String)"), placeholderImage: nil)
            }
            self.labelPersonNameSubmissionOutlet.text = userId["name"] as? String
            self.labelPersonEmailSubmissionOutlet.text = userId["email"] as? String
            self.labelContactNumberSubmissionOutlet.text = userId["phone"] as? String
            self.labelDescriptionSubmissionOutlet.text = userId["description"] as? String
            self.labelSpeechToTextOutlet.text = userId["speech_text"] as? String
            self.labelDateTimeOutlet.text = "\(String(describing: repositoryTaskDetailData[0].userEndDate!))" + "\(" ")" + "\(String(describing: repositoryTaskDetailData[0].user_end_time!))"
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        labelDetailOutlet.isUserInteractionEnabled = true
        labelDetailOutlet.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction1))
        labelDescriptionSubmissionOutlet.isUserInteractionEnabled = true
        labelDescriptionSubmissionOutlet.addGestureRecognizer(tap1)

        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction2))
        labelSpeechToTextOutlet.isUserInteractionEnabled = true
        labelSpeechToTextOutlet.addGestureRecognizer(tap2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewParentOutlet.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.nameOfFunction), name: NSNotification.Name(rawValue: "nameOfNotificationCancel"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.nameOfFunction), name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)
    }
    
//    override func viewDidLayoutSubviews() {
//
//        let view1AndStackView = self.viewparentOutlet1.frame.origin.y + self.viewparentOutlet1.frame.size.height
//        print(view1AndStackView)
//        let view2AndButton = self.viewParentOutlet2.frame.origin.y + self.viewParentOutlet2.frame.size.height // + 100
//        print(view2AndButton)
//        self.scrollViewOutlet.contentSize.height = view1AndStackView + view2AndButton
//        print(self.scrollViewOutlet.contentSize.height)
//    }
    
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
        
        self.repositoryTaskDetailData.removeAll()
        self.repositoryTaskDetailData.append(Repository(getUserList: notif.object as! NSDictionary))
        
        self.labelTaskIdOutlet.text = String(repositoryTaskDetailData[0].user_Id!)
        self.labelPersonNameOutlet.text = repositoryTaskDetailData[0].user_contact_person!
        self.labelEmailOutlet.text = repositoryTaskDetailData[0].user_contact_email!
        self.labelContactNumberOutlet.text = repositoryTaskDetailData[0].user_contact_tel!
        self.labelDetailOutlet.text = repositoryTaskDetailData[0].user_issue
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        
        self.popUpController(taskUuid: repositoryTaskDetailData[0].useruuid!, detail: repositoryTaskDetailData[0].user_issue!)
    }
    
    @objc func tapFunction1(sender:UITapGestureRecognizer) {
        
        let userId = repositoryTaskDetailData[0].task_process!

        self.popUpController(taskUuid: repositoryTaskDetailData[0].useruuid!, detail: userId["description"] as? String ?? "")
    }

    @objc func tapFunction2(sender:UITapGestureRecognizer) {

        let userId = repositoryTaskDetailData[0].task_process!

        self.popUpController(taskUuid: repositoryTaskDetailData[0].useruuid!, detail: userId["speech_text"] as? String ?? "")
    }
    
    func popUpController(taskUuid: String, detail: String)
    {
        let objPopUpViewController = kStoryBoard.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        
        viewParentOutlet.isHidden = false
        
        objPopUpViewController.stringTaskUuid = taskUuid
        objPopUpViewController.stringDetail = detail
        
        objPopUpViewController.modalPresentationStyle = .overCurrentContext
        objPopUpViewController.modalTransitionStyle = .crossDissolve
        
        self.present(objPopUpViewController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customizeNavigationBarWithColoredBar(isVisible: true)
        self.navigationItem.hidesBackButton = false
        
        methodNavigationBarBackGroundAndTitleColor(titleString: "Detail Page")
    }
    
    @IBAction func buttonMapViewClicked(_ sender: Any) {
        
        if ButtonMapViewOutlet.currentTitle == "Map View" {
            let objAdminMapPageViewController = kStoryBoard.instantiateViewController(withIdentifier: kAdminMapPageViewController) as! AdminMapPageViewController
            objAdminMapPageViewController.counter = 0
            
            let userId = repositoryTaskDetailData[0].userUser!
            
            objAdminMapPageViewController.stringUserUuid = userId["uuid"] as! String
            navigationController?.pushViewController(objAdminMapPageViewController, animated: true)
        }
        
        if ButtonMapViewOutlet.currentTitle == "Invoice" {
            let objInvoicePageViewController = kStoryBoard.instantiateViewController(withIdentifier: kInvoicePageViewController) as! InvoicePageViewController
            objInvoicePageViewController.repositoryInvoiceData = repositoryTaskDetailData
            navigationController?.pushViewController(objInvoicePageViewController, animated: true)
        }
    }
    
}
