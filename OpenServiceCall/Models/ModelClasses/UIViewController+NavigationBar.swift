
import UIKit
import SJSwiftSideMenuController

extension UIViewController {    
    
    // Method to add side menu with clickable.
//    func customizeNavigationBarWithSlideButton() {
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        self.navigationItem.hidesBackButton = false
//
//        //Code for add slideButton
//        let btnName = UIButton()
//        btnName.setImage(UIImage(named: "circle"), for: UIControlState())
//        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        btnName.addTarget(self, action: #selector(self.methodHomeButtonPress), for: .touchUpInside)
////        btnName.addTarget(appDelegate.objRevealViewController, action: #selector(appDelegate.objRevealViewController.revealToggle(_:)), for: .touchUpInside)
//
//        let leftBarButton = UIBarButtonItem()
//        leftBarButton.customView = btnName
//        self.navigationItem.leftBarButtonItem = leftBarButton
//
//        /* let revealButtonItem = UIBarButtonItem(image: UIImage(named: "Email")!, style: .plain, target: appDelegate.objRevealViewController, action: #selector(appDelegate.objRevealViewController.revealToggle(_:)))
//         self.navigationItem.leftBarButtonItem! = revealButtonItem */
//    }
//
//    // method to set the navigation bar title and titlecolor
    func methodNavigationBarBackGroundAndTitleColor(titleString: String)  {
        
//        let imageView = UIImageView(image: UIImage(named: "MenuNavigationBar"))
//        imageView.contentMode = .scaleAspectFit
//        navigationItem.titleView = imageView
        
        self.title = titleString
        self.navigationController?.navigationBar.isTranslucent = false
        _ = ((self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "segoeui", size: 20) as Any]) != nil)
        self.navigationController?.navigationBar.barTintColor = kAppColor
    }
    
    func sideMenuImage() {
        if let image : UIImage = UIImage(named: "menu") as UIImage? {
            SJSwiftSideMenuController .showLeftMenuNavigationBarButton(image: image)
        }
        SJSwiftSideMenuController.enableDimbackground = true
    }
//
//    // Alert Controller
//    func showAlertWithVC(){
//        AJAlertController.initialization().showAlert(aStrMessage: "Do you want to Log Out ?", aCancelBtnTitle: "NO", aOtherBtnTitle: "YES") { (index, title) in
//            print(index,title)
//
//            switch(title){
//            case "YES":
//                self.methodForSignOut()
//            case "NO":
//                print("No")
//            default:
//                break
//            }
//
//        }
//    }
//
//    func showAlertWithOkButton(){
//        AJAlertController.initialization().showAlertWithOkButton(aStrMessage: "Please choose option to Log In") { (index, title) in
//            print(index,title)
//        }
//    }

    func methodForSignOut(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

//        let manager = LoginManager()
//        manager.logOut()
//
//        GIDSignIn.sharedInstance().disconnect()

        UserDefaultsManager.methodForRemoveObjectValue(kIsLoggedIn)
        appDelegate.methodForLogout()
    }
    //
    
    // Method for add Back Button on NavigationBar
    func customizeNavigationBar(isVisible:Bool)
    {
        self.navigationController?.isNavigationBarHidden = false

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor .black

        //Code for add Back Button
        let buttonBack = UIButton()
        buttonBack.frame = CGRect(x: 0, y: 5, width: 30, height: 30)
        buttonBack.setTitleColor(UIColor.white, for: UIControl.State())
        buttonBack.setImage(UIImage(named:"Back"), for: UIControl.State())
        buttonBack.addTarget(self, action: #selector(self.back), for: .touchUpInside)

        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = buttonBack
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.leftBarButtonItem?.isEnabled = isVisible
    }
    
//    // OR
    func customizeNavigationBarWithColoredBar(isVisible : Bool)
    {
        self.navigationController?.isNavigationBarHidden = false

        self.navigationController?.navigationBar.isTranslucent = false
        _ = ((self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]) != nil)
        self.navigationController?.navigationBar.barTintColor = kAppColor

        //Code for add Back Button
        let buttonBack = UIButton()
        buttonBack.frame = CGRect(x: 0, y: 5, width: 30, height: 30)
        buttonBack.setTitleColor(UIColor.white, for: UIControl.State())
        buttonBack.setImage(UIImage(named:"Back"), for: UIControl.State())
        buttonBack.addTarget(self, action: #selector(self.back), for: .touchUpInside)

        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = buttonBack
        self.navigationItem.leftBarButtonItem = leftBarButton;
        self.navigationItem.leftBarButtonItem?.isEnabled = isVisible
    }
    
    // OR
    
    func customizeNavigationBarToController() {
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.isTranslucent = false
        _ = ((self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]) != nil)
        self.navigationController?.navigationBar.barTintColor = kAppColor
        
        //Code for add Back Button
        let buttonBack = UIButton()
        buttonBack.frame = CGRect(x: 0, y: 5, width: 30, height: 30)
        buttonBack.setTitleColor(UIColor.white, for: UIControl.State())
        buttonBack.setImage(UIImage(named:"Back"), for: UIControl.State())
        buttonBack.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = buttonBack
        self.navigationItem.leftBarButtonItem = leftBarButton;
        self.navigationItem.leftBarButtonItem?.isEnabled = true
    }

//   Right BarButton
    func rightBarButtonClicked() {

        var image = UIImage(named: "AddTask")!
        image = image.withRenderingMode(.alwaysOriginal)
        AppDelegate.sharedSegmentValue.sharedUserAssignedValue = 101
        let rightBtn = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.rightBtnClick))
        rightBtn.tintColor = UIColor.white

        navigationItem.rightBarButtonItem = rightBtn
    }

//    func rightBarButtonForAddDogsClicked() {
//
//        var image = UIImage(named: "AddIcon")!
//        image = image.withRenderingMode(.alwaysOriginal)
//        let rightBtn = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(MyDogsViewController.rightBtnClickForAddDogs))
//        rightBtn.tintColor = UIColor.white
//
//        navigationItem.rightBarButtonItem = rightBtn
//    }
//
//    func rightBarButtonForEditClicked() {
//
//        var image = UIImage(named: "EditButton")!
//        image = image.withRenderingMode(.alwaysOriginal)
//        let rightBtn = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.rightBtnClickForEdit))
//        rightBtn.tintColor = UIColor.white
//
//        navigationItem.rightBarButtonItem = rightBtn
//    }

    @objc func rightBtnClick() {
        // code for right Button

        let objAdminAddTaskViewController = kStoryBoard.instantiateViewController(withIdentifier: kAdminAddTaskViewController) as! AdminAddTaskViewController
        navigationController?.pushViewController(objAdminAddTaskViewController, animated: true)
    }

//    @objc func rightBtnClickForAddDogs() {
//        // code for right Button
//        print("Abhishek Sharma")
//
//        let objMicrochipNumberViewController = kStoryBoard.instantiateViewController(withIdentifier: kMicrochipNumberViewController) as! MicrochipNumberViewController
//        objMicrochipNumberViewController.stringCheckValueForSideMenuIcon = "PlusIcon"
//        navigationController?.pushViewController(objMicrochipNumberViewController, animated: true)
//    }
//
//    @objc func rightBtnClickForEdit() {
//        // code for right Button
//        print("Abhishek Sharma")
//    }

    // method to go back to previous viewcontrollers.
    @objc func back() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func BackToController() {
        let objAdminUserListViewController = kStoryBoard.instantiateViewController(withIdentifier: kAdminUserListViewController) as! AdminUserListViewController
        navigationController?.pushViewController(objAdminUserListViewController, animated: false)
    }

//       // method to perform action when we select menu button.
//     @IBAction func methodHomeButtonPress(_ sender: AnyObject) {
//        _ = self.navigationController?.popViewController(animated: true)
//
//     }
//
//  /*   func methodForShowHalfSlider(){
//
//     let settingView = self.storyboard!.instantiateViewController(withIdentifier: "SlideMenuViewController")
//     self.addChildViewController(settingView)
//     self.view.addSubview(settingView.view)
//     settingView.didMove(toParentViewController: self)
//
//     (UIApplication.shared.delegate! as! AppDelegate).window!.addSubview(settingView.view)
//     settingView.view.frame = CGRect(x: -(self.view.bounds.size.width), y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
//     print("frame =\(NSStringFromCGRect(settingView.view.frame))")
//     UIView.animate(withDuration: 0.5, animations: {() -> Void in
//     settingView.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
//     print("frame =\(NSStringFromCGRect(settingView.view.frame))")
//     }, completion: {(finished: Bool) -> Void in
//     })
//
//     } */
//
}
