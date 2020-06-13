
import UIKit

class ChangePasswordViewController: UIViewController {
    
    // View Outlet
    @IBOutlet weak var viewOTPOutlet: UIView!
    @IBOutlet weak var viewPasswordOutlet: UIView!
    @IBOutlet weak var viewConfirmPasswordOutlet: UIView!
    
    // TextField Outlet
    @IBOutlet weak var textFieldOtpOutlet: UITextField!
    @IBOutlet weak var textFieldPasswordOutlet: UITextField!
    @IBOutlet weak var textFieldConfirmPasswordOutlet: UITextField!
    
    // Button Outlet
    @IBOutlet weak var buttonChangePasswordOutlet: UIButton!
    
    var stringUUIDValue = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewOTPOutlet.viewCornerRadius()
        viewPasswordOutlet.viewCornerRadius()
        viewConfirmPasswordOutlet.viewCornerRadius()
        
        buttonChangePasswordOutlet.buttonLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customizeNavigationBar(isVisible: true)
    }
    
    @IBAction func buttonChangePasswordClicked(_ sender: Any) {
        apiChangePassword()
    }
    
    func apiChangePassword()
    {
        if self.textFieldOtpOutlet.text != "" && self.textFieldPasswordOutlet.text != "" && self.textFieldConfirmPasswordOutlet.text != ""
        {
            if isPasswordSame(password: self.textFieldPasswordOutlet.text!, confirmPassword: self.textFieldConfirmPasswordOutlet.text!)
            {
                if Reachability.isConnectedToNetwork() == true
                {
                    showHud()
                    let params = ["otp": self.textFieldOtpOutlet.text!, "password": self.textFieldPasswordOutlet.text!, "uuid": stringUUIDValue]
                    print(params)
                    
                    ServiceManager.POSTServerRequest(kResetPasswordUrl, andParameters: params , success:
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
//                                self.view.makeToast(messageString)
                                let objViewController = kStoryBoard.instantiateViewController(withIdentifier: kViewController) as! ViewController
                                self.navigationController?.pushViewController(objViewController, animated: false)
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
            else
            {
                self.view.makeToast(kPasswordMatchingWarningMessage)
            }
            
        }
        else
        {
            self.view.makeToast(kFillFieldsWarningMessage)
        }
    }
    
}

