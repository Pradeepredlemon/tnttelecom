
import UIKit

class UpdateProfileViewController: UIViewController {
    
    // UiView Outlet
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewEmailAddress: UIView!
//    @IBOutlet weak var viewPassword: UIView!
//    @IBOutlet weak var viewCity: UIView!
//    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewAddress: UIView!
//    @IBOutlet weak var viewZipcode: UIView!
    
    // TextField Outlet
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmailAddress: UITextField!
//    @IBOutlet weak var textFieldPassword: UITextField!
//    @IBOutlet weak var textFieldCity: UITextField!
//    @IBOutlet weak var textFieldState: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
//    @IBOutlet weak var textFieldZipcode: UITextField!
    
    // Button Outlet
    @IBOutlet weak var buttonUpdateOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewName.viewCornerRadius()
        viewEmailAddress.viewCornerRadius()
//        viewCity.viewCornerRadius()
//        viewState.viewCornerRadius()
        viewPhone.viewCornerRadius()
        viewLastName.viewCornerRadius()
        viewAddress.viewCornerRadius()
//        viewZipcode.viewCornerRadius()

        buttonUpdateOutlet.buttonLayout()
        
        sideMenuImage()
        methodNavigationBarBackGroundAndTitleColor(titleString: "My Profile")
        
        let outData = UserDefaults.standard.data(forKey: "USERDATA")
        let dictionaryValues: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        textFieldName.text = (dictionaryValues.value(forKey: "firstname")! as? String)!
        textFieldLastName.text = (dictionaryValues.value(forKey: "lastname")! as? String)!
        textFieldAddress.text = (dictionaryValues.value(forKey: "address")! as? String)!
//        textFieldZipcode.text = (dictionaryValues.value(forKey: "zipcode")! as? String)!
        textFieldEmailAddress.text = (dictionaryValues.value(forKey: "email")! as? String)!
//        textFieldCity.text = (dictionaryValues.value(forKey: "city")! as? String)!
//        textFieldState.text = (dictionaryValues.value(forKey: "state")! as? String)!
        textFieldPhone.text = (dictionaryValues.value(forKey: "mobile")! as? String)!
    }
    
    @IBAction func buttonUpdateClicked(_ sender: Any) {
        apiUpdateProfile()
    }
    
    func apiUpdateProfile()  {
        
        let outData = UserDefaults.standard.data(forKey: "USERDATA")
        var dictionaryValues: NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        print("dictionaryValues--->",dictionaryValues)
        let dictionaryValuesNew : NSMutableDictionary = dictionaryValues.mutableCopy() as! NSMutableDictionary
        
        if self.textFieldName.text != "" && self.textFieldEmailAddress.text != "" && self.textFieldPhone.text != "" && self.textFieldLastName.text != "" && self.textFieldAddress.text != ""
        {
            if validatePhoneNumber(phoneNumber: self.textFieldPhone.text!)
            {
                if self.textFieldPhone.text?.characters.count == 10
                {
                    if !validateEmail(enteredEmail: textFieldEmailAddress.text!)
                    {
                        self.view.makeToast(kEmailMessage)
                    }
                    else
                    {
                        if Reachability.isConnectedToNetwork() == true
                        {
                            showHud()
                            let params = ["email": self.textFieldEmailAddress.text! , "firstname": self.textFieldName.text!, "mobile": self.textFieldPhone.text!, "uuid": (dictionaryValues.value(forKey: "uuid")! as? String)!, "lastname": self.textFieldLastName.text!, "address": self.textFieldAddress.text!]
                            print(params)
                            
                            ServiceManager.POSTServerRequest(kUpdateProfile, andParameters: params , success:
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
//                                        self.view.makeToast(messageString)
                                        
                                        let data = response?["payload"] as? NSDictionary
                                        print(data ?? AnyObject.self)
                                        
                                        dictionaryValuesNew["firstname"] = data?["firstname"]
                                        dictionaryValuesNew["email"] = data?["email"]
                                        dictionaryValuesNew["city"] = data?["city"]
                                        dictionaryValuesNew["state"] = data?["state"]
                                        dictionaryValuesNew["mobile"] = data?["mobile"]
                                        dictionaryValuesNew["lastname"] = data?["lastname"]
                                        dictionaryValuesNew["address"] = data?["address"]
                                        dictionaryValuesNew["zipcode"] = data?["zipcode"]

                                        let refValueNew = Constants.refs.databaseRoot.child("users").child(data?["uuid"] as! String)
                                        refValueNew.updateChildValues(["username": data?["firstname"]!, "email": data?["email"]!])

                                        print(dictionaryValuesNew)
                                        dictionaryValues = dictionaryValuesNew .mutableCopy() as! NSDictionary
                                        print("dictionaryValues--->",dictionaryValues)
                                        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: dictionaryValues), forKey: "USERDATA")
                                        
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
                else{
                    self.view.makeToast(kPhoneNumberLengthWaningMessage)
                }
            }
            else
            {
                self.view.makeToast(kPhoneNumberWarningMessage)
            }
        }
        else{
            self.view.makeToast(kFillFieldsWarningMessage)
        }
    }
    
}
