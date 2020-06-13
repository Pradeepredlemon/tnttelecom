
import UIKit

class ModelController: NSObject {
  
/*    //Method for get Build Version and Build Number
    class func methodForApplicationVersion() ->String{
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        let version = nsObject as! String
        
        let buildNumber: AnyObject? =  Bundle.main.infoDictionary?["CFBundleVersion"] as AnyObject?
        let number = buildNumber as! String

        let stringApplicationVersion = "v"+version+"("+number+")"
        return stringApplicationVersion
    }
    
    //Method for get SERVER ERRORS
    class func showServerErrorMsgWith(_ error: NSError) {
        var errorMessage: String
        if error.code == SERVER_COULD_NOT_FOUND || error.code == CONNECTION_LOST || error.code == INTERNET_OFFLINE {
            errorMessage = error.localizedDescription
            if error.code == SERVER_COULD_NOT_FOUND {
                errorMessage = "Connection failed"
            }
            let noMoreDataAlertView: UIAlertView = UIAlertView(title: kAppName, message: errorMessage, delegate:nil, cancelButtonTitle:nil, otherButtonTitles: kOkButton)
            noMoreDataAlertView.show()
        }
        else {
            // errorMessage = @"Server error";
            // errorMessage = @"Server error";
        }
    }
    
    //Method for show alert into this aaplication
    
    class func showAlert(_ alertTitle: String, andMessage alertMessage: String, withController view: UIViewController){
        
        let alert: UIAlertView = UIAlertView(title:alertTitle, message:alertMessage, delegate:nil, cancelButtonTitle:nil, otherButtonTitles:kOkButton)
        
        alert.show()
    }
    */
/*    //Method for check validation of email

    class func validateEmail(_ strEmail: String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", kRegexEmailValidate)
        if emailTest.evaluate(with: strEmail) == false {
            return false
        }
        else {
            return true
        }
    }
    
    class func methodStatusBarColorChange() {
        UIApplication.shared.isStatusBarHidden =  false
//        UIApplication.shared.statusBarStyle = .lightContent
        let statusBar:UIView = UIApplication.shared.value(forKey: "statusBar")as!UIView
            statusBar.backgroundColor = UIColor(red: 57/255, green: 147/255, blue: 212/255, alpha: 1.0)
//        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
//            
////            statusBar.backgroundColor = colorPelorous
//            statusBar.backgroundColor = UIColor(red: 57/255, green: 147/255, blue: 212/255, alpha: 1.0)
//        }
    }
    
    class func methodForFetchValues(fromRedirectURL stringAbsolute: String) -> NSMutableDictionary {
        let queryStringDictionary = NSMutableDictionary()
        let stringAbsoluteResponse = stringAbsolute.replacingOccurrences(of: "#", with: "&")
        let urlComponents = stringAbsoluteResponse.components(separatedBy: "&")
        for keyValuePair: String in urlComponents {
            let pairComponents = keyValuePair.components(separatedBy: "=")
            let key = pairComponents.first!.removingPercentEncoding!
            let value = pairComponents.last!.removingPercentEncoding!
            queryStringDictionary[key] = value
        }
        return queryStringDictionary
    }
    
    //Method for convert url into UIImage
    class func methodGetImageFromUrl(_ stingUrl:String)->UIImage{
       
       let stingUrl = stingUrl.replacingOccurrences(of: " ", with: "%20")
        var image = UIImage()
        var data: Data? = nil
        let url = URL(string: (stingUrl))!
        data = try? Data(contentsOf: url)
        if data == nil {
            data = UIImageJPEGRepresentation(image, 1)
        }
        image = UIImage(data: data!)!
        return image
    }
    
    //Method for break time string
    class func methodForBreakTimeString(_ stingUrl:String)->String{
        
        let array = stingUrl.components(separatedBy: "T")
        let stringTime =  array[0] as String
        return stringTime
    }  */
    
}
