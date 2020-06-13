
import UIKit

class ForgotPasswordViewController: UIViewController {
    
    // UiView Outlet
    @IBOutlet weak var viewEmailOutlet: UIView!
    
    // TextField Outlet
    @IBOutlet weak var textFieldEmail: UITextField!
    
    // Button Outlet
    @IBOutlet weak var buttonResetYourPasswordOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewEmailOutlet.viewCornerRadius()
        buttonResetYourPasswordOutlet.buttonLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customizeNavigationBar(isVisible: true)
    }
    
    @IBAction func buttonResetYourPasswordClicked(_ sender: Any) {
        apiForgotPassword()
    }
    
    func apiForgotPassword()
    {
        if self.textFieldEmail.text != ""
        {
            if !validateEmail(enteredEmail: textFieldEmail.text!)
            {
                self.view.makeToast(kEmailMessage)
            }
            else
            {
                if Reachability.isConnectedToNetwork() == true
                {
                    showHud()
                    let params = ["email": self.textFieldEmail.text!]
                    print(params)
                    
                    ServiceManager.POSTServerRequest(kForgotPasswordUrl, andParameters: params , success:
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
                                let payloadDictionary = response?["payload"] as! NSDictionary
                                let uuidString = payloadDictionary["uuid"] as! String
                                
                                let objChangePasswordViewController = kStoryBoard.instantiateViewController(withIdentifier: kChangePasswordViewController) as! ChangePasswordViewController
                                objChangePasswordViewController.stringUUIDValue = uuidString
                                self.navigationController?.pushViewController(objChangePasswordViewController, animated: true)
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
        else
        {
            self.view.makeToast(kRegistrationWarningMessage)
        }
    }
    
}
