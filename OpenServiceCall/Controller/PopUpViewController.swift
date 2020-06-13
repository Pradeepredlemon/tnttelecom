
import UIKit

class PopUpViewController: UIViewController, UITextViewDelegate {
        
    // Button Outlet
    @IBOutlet weak var buttonSubmitOutlet: UIButton!
    
    // View Outlet
    @IBOutlet weak var viewOutlet: UIView!
    
    // TextView Outlet
    @IBOutlet weak var textViewOutlet: UITextView!
    
    var stringTaskUuid = String()
    var stringLatitude = String()
    var stringLongitude = String()
    var stringDetail = String()
    
    var placeholderLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(stringDetail)
        
        buttonSubmitOutlet.buttonLayout()
        viewOutlet.viewCornerRadius()
        
        textViewOutlet.layer.borderWidth = 1
        
        textViewOutlet.delegate = self
        textViewOutlet.text = stringDetail
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Type here..."
        placeholderLabel.font = UIFont.systemFont(ofSize: (textViewOutlet.font?.pointSize)!) 
        placeholderLabel.sizeToFit()
        textViewOutlet.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textViewOutlet.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textViewOutlet.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @IBAction func buttonCancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nameOfNotificationCancel"), object: nil)
    }
    
    @IBAction func buttonSubmitClicked(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)
        
//        apiStartAndStop(apiString: kUpdateTaskDescription)
    }
    
//    func apiStartAndStop(apiString: String)
//    {
//        let outData = UserDefaults.standard.data(forKey: "USERDATA")
//        let dictionaryValues: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
//
//        if Reachability.isConnectedToNetwork() == true
//        {
//            showHud()
//            let params = ["issue": textViewOutlet.text!, "task_uuid": stringTaskUuid] as [String : Any]
//            print(params)
//
//            ServiceManager.POSTServerRequest(apiString, andParameters: params as! [String : String] , success:
//                {
//                    response in
//                    print("response----->",response ?? AnyObject.self)
//
//                    if response is NSDictionary
//                    {
//                        self.hideHUD()
//
//                        let statusString = response?["success"] as! Bool
//                        let messageString = response?["display_msg"] as! String
//
//                        guard statusString == true
//                            else
//                        {
//                            self.view.makeToast(messageString)
//                            return
//                        }
//
//                        self.dismiss(animated: true, completion: nil)
//
//                        let payloadDictionary = response?["payload"] as! NSDictionary
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nameOfNotification"), object: payloadDictionary)
//                    }
//            }
//                ,failure:
//                {
//                    error in
//                    self.hideHUD()
//            })
//        }
//        else{
//            self.view.makeToast(kNetworkError)
//        }
//    }
    
}
