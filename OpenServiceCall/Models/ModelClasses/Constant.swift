
import UIKit
import Foundation
import QuartzCore
import RSLoadingView
import Firebase
import GoogleMaps

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("MapDetails")
    }
}


struct State {
    let name: String
    let uuid: String
    let long: CLLocationDegrees
    let lat: CLLocationDegrees
}


let kMain                               = "Main"
let kAppName                            = "SecurityCameraExpert"
let kAppColor                           = UIColor(red: 0.0/255.0, green: 201.0/255.0, blue: 241.0/255.0, alpha: 1.0)
let kStoryBoard : UIStoryboard          = UIStoryboard(name: kMain, bundle: nil)
let appDelegate                         = UIApplication.shared.delegate as! AppDelegate


// Controllers
let kAppDelegate                            = "AppDelegate"
let kViewController                         = "ViewController"
let kRegisterViewController             = "RegisterViewController"
let kAdminMapPageViewController         = "AdminMapPageViewController"
let kForgotPasswordViewController       = "ForgotPasswordViewController"
let kChangePasswordViewController       = "ChangePasswordViewController"
let kHomePageViewController             = "HomePageViewController"
let kNewTaskViewController              = "NewTaskViewController"
let kAdminAddTaskViewController         = "AdminAddTaskViewController"
let kHomePageTableViewCell              = "HomePageTableViewCell"
let kDetailPageViewController           = "DetailPageViewController"
let kUpdateProfileViewController        = "UpdateProfileViewController"
let kEstimatesViewController            = "EstimatesViewController"
let kAdminUserListViewController         = "AdminUserListViewController"
let kNotificationViewController         = "NotificationViewController"
let kNotificationTableViewCell          = "NotificationTableViewCell"
let kSideMenuViewController             = "SideMenuViewController"
let kSideMenuTableViewCell              = "SideMenuTableViewCell"
let kInvoicePageViewController          = "InvoicePageViewController"
let kAdminTaskDetailViewController      = "AdminTaskDetailViewController"
let kFireBaseLoginUrl                   = "https://securitycameraex-1553599159460.firebaseio.com"
let kAdminMapUserListingViewController  = "AdminMapUserListingViewController"
let kAdminCalendarUserListingViewController = "AdminCalendarUserListingViewController"
let kNewTaskDetailPageViewController        = "NewTaskDetailPageViewController"
//


// Cells
let kHomePageCategoryTableViewCell      = "HomePageCategoryTableViewCell"
//

// SplashScreenDetails texts and images.
let kGotIt                              = "GOT IT"
let kOutDoorActivity                    = "OutDoor Activity"
let kIndoorActivity                     = "InDoor Activity"
let kIsLoggedIn                         = "isLogin"

let kFoodLogo                           = "food"
let kNightLifeLogo                      = "party"
//


// LoginScreen Texts and Images
let kEmailId                            = "Email Id"
let kPassword                           = "Password"
let kNewPassword                        = "New Password"
//



// Picker Messages
let kSelectCategory = "Select Category"
//

// Web Services
let kBaseUrl                            = "http://rlhosting.co.in/tnt/public/api/"
let kLoginUrl                           = kBaseUrl + "login"
let kLoginAdminUrl                      = kBaseUrl + "login_as_admin"
let kRegisterUrl                        = kBaseUrl + "register_user"
let kForgotPasswordUrl                  = kBaseUrl + "forgot_password"
let kAddSpeechSignatureUrl = kBaseUrl + ""

let kResetPasswordUrl                   = kBaseUrl + "reset_password"
let kUpdateProfile                      = kBaseUrl + "update_profile"
let kCategory                           = kBaseUrl + "category"
let kSubCategory                        = kBaseUrl + "category/subCategory"
let kProductList                        = kBaseUrl + "product"
let kProductDetails                     = kBaseUrl + "product/productdetails"
let kNewArrival                         = kBaseUrl + "product/newarrival"
let kNewTasksUrl                        = kBaseUrl + "tasks/view"
let kStartTask                          = kBaseUrl + "tasks/start"
let kStopTask                           = kBaseUrl + "tasks/stop"
let kUserLists                          = kBaseUrl + "users"
let kViewTasks                          = kBaseUrl + "view_tasks"
let kViewTasksNotifications             = kBaseUrl + "view_tasks_notifications"
let kAddEvent                           = kBaseUrl + "tasks/add"
let klogoutUrl                          = kBaseUrl + "logout"
let kUpdateTaskDescription              = kBaseUrl + "update_task_description"
let kCheckInUrl                         = kBaseUrl + "tasks/check_in"
let kNewTaskUrl                         = kBaseUrl + "tasks/notifications"
let kAcceptTaskUrl                      = kBaseUrl + "tasks/accept"
let kRejectTaskUrl                      = kBaseUrl + "tasks/reject"
let kAddEstimateUrl                     = kBaseUrl + "estimates/add"
let kImageUrl                           = "http://rldevtesting.com/flannels/assets/product_images/"
let kSubServicesImages                  = "sub_services_images/"

//


// //Alert Messages
let kNetworkError                       = "Network error. Please try again."
let kFillFieldsWarningMessage           = "Please enter required fields"
let kSignOutMessage                     = "Are You Sure You Want To Sign Out?"
let kEmailMessage                       = "Please Enter Correct Email"
let kRegistrationWarningMessage         = "Please enter required fields"
let kPhoneNumberWarningMessage          = "Please enter correct phone number"
let kPhoneNumberLengthWaningMessage     = "Phone Number must be 10 digit"
let kPasswordMatchingWarningMessage     = "Password mismatch with Confirm Password"
let kOldNewPasswordMatchMessage         = "Your old password matches with your new password"

//


class Constant: NSObject {
    
}

// Extensions

extension UIButton
{
    func buttonLayout()  {
        layer.cornerRadius = 7
    }
    
    func buttonBorder()  {
        layer.cornerRadius = 7
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
    }
    
    func buttonShadow()  {
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowColor = UIColor.black.cgColor
        layer.cornerRadius = frame.width/2
        layer.shadowOffset = CGSize(width:0.0, height:1.0)
    }
    
    //    func buttonCategoryCoordinates() {
    //        contentHorizontalAlignment = .left
    //        contentVerticalAlignment = .bottom
    //        contentEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 0)
    //    }
}

extension UILabel
{
    func labelOnSideMenu(labelName: UILabel, titleName: String)  {
        labelName.backgroundColor = kAppColor
        labelName.text = titleName
        labelName.textColor = UIColor.black
        labelName.textAlignment = .center
        labelName.font = UIFont (name: "Helvetica Neue", size: 15)!
    }
    
    func labelLayout()  {
        layer.cornerRadius = 7
        layer.masksToBounds = true
    }
    
    func labelLayoutForDetailPage() {
        layer.cornerRadius = 7
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
    }
}

extension UITextView
{
    func textCornerSide() {
        layer.cornerRadius = 7
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
    }
}

extension UIImageView {
    func imageData(image : UIImageView) {
        //        layer.cornerRadius = image.frame.size.height/2
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
    }
    
    func imageCircularData()  {
        layer.borderWidth = 2
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        self.layer.mask = maskLayer
    }
    
}

extension UIViewController {
    
    func showHud() {
        let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
        loadingView.show(on: view)
    }
    
    func hideHUD() {
        RSLoadingView.hide(from: view)
    }
    
    func hideNavigationBar(){
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar() {
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func showBackButton(){
        self.navigationItem.hidesBackButton = false
    }
    
    func hideBackButton(){
        self.navigationItem.hidesBackButton = true
    }
}

extension UITextField {
    func textFieldCornerRadius (textField : UITextField){
        layer.cornerRadius = 8
    }

//    func textFieldPlaceholderColor(textFieldName: String) {
//        self.attributedPlaceholder = NSAttributedString(string: textFieldName, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
//    }
    
}

extension UISegmentedControl {
    func font(name:String?, size:CGFloat?) {
        let attributedSegmentFont = NSDictionary(object: UIFont(name: name!, size: size!)!, forKey: NSAttributedString.Key.font as NSCopying)
        setTitleTextAttributes((attributedSegmentFont as! [NSAttributedString.Key : Any]), for: .normal)
    }
}

extension UIView {
    func viewCornerRadiusForHorizontalLine (view : UIView){
        
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.white.cgColor
        yourViewBorder.lineDashPattern = [2, 2]
        yourViewBorder.frame = view.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: view.bounds).cgPath
        view.layer.addSublayer(yourViewBorder)
        
        //        let backgroundView = UIImageView(image: UIImage(named: kEditTextBackground))
        //        view.addSubview(backgroundView)
    }
    
    //    func viewCornerRadiusForVerticalLine (view : UIView){
    //        let backgroundView = UIImageView(image: UIImage(named: kCenterLine))
    //        view.addSubview(backgroundView)
    //    }
    
    func viewCornerRadius (){
        layer.cornerRadius = 7
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
    }
}
