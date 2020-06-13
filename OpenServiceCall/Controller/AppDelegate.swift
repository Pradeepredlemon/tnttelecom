
import UIKit
import CoreData
import IQKeyboardManagerSwift
import SJSwiftSideMenuController
import OneSignal
import GoogleMaps
import Firebase
import SwiftBackgroundLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OSSubscriptionObserver {

    static let sharedSegmentValue = AppDelegate()
    var sharedSegmentStringValue = NSInteger()
    var sharedUserAssignedValue = NSInteger()
    
    var window: UIWindow?

    var locationManager = TrackingHeadingLocationManager()
    var backgroundLocationManager = BackgroundLocationManager(regionConfig: RegionConfig(regionRadius: 100.0))
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GoogleApi.shared.initialiseWithKey("AIzaSyAc7O_rgW-uWW5UFJhy9Gb64DDeClHlPUk")
        
        // Add your AppDelegate as an subscription observer
        OneSignal.add(self as OSSubscriptionObserver)

        if launchOptions?[UIApplication.LaunchOptionsKey.location] != nil {
            BackgroundDebug().write(string: "UIApplicationLaunchOptionsLocationKey")
            
            backgroundLocationManager.startBackground() { result in
                if case let .Success(location) = result {
                    LocationLogger().writeLocationToFile(location: location)
                }
            }
        }
        
        FirebaseApp.configure()        
        GMSServices.provideAPIKey("AIzaSyDSMVowUUhgJCbCjNm73WJrIw3dDZwEfpA")
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions, appId: "02a417d7-9d92-4a5e-b94c-21c80a9d479a", handleNotificationAction: nil, settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        
        if UserDefaultsManager.methodForFetchBooleanValue(kIsLoggedIn) as Bool
        {
            self.methodForUserLogin()
        }
        else
        {
            self.methodForLogout()
        }
        
        IQKeyboardManager.shared.enable = true
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        UserDefaultsManager.methodForSaveStringObjectValue(deviceID, andKey: "DEVICEID")
        
        return true
    }
    
    // After you add the observer on didFinishLaunching, this method will be called when the notification subscription property changes.
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(String(describing: stateChanges))")
        
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        
         print("Current JGJGHJDSGDKGJGJGK \(stateChanges.to.pushToken)")
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            let userPlayerId = playerId
            UserDefaults.standard.set(userPlayerId, forKey: "NOTIFICATION")
        }
    }
    
    //  Login
    func methodForUserLogin(){
        
        if UserDefaults.standard.string(forKey: "LOGIN") == "USER" {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let sideMenuData = ["HOME", "NEW TASK", "COMPLETED TASK", "MY PROFILE", "ESTIMATES"]
            
            AppDelegate.sharedSegmentValue.sharedSegmentStringValue = 1
            
            let mainVC = SJSwiftSideMenuController()
            
            let sideVC_L : SideMenuViewController = (kStoryBoard.instantiateViewController(withIdentifier: kSideMenuViewController) as? SideMenuViewController)!
            sideVC_L.menuItems = (sideMenuData as NSArray?)!
            
            let rootVC = kStoryBoard.instantiateViewController(withIdentifier: kHomePageViewController) as! HomePageViewController
            
            SJSwiftSideMenuController.setUpNavigation(rootController: rootVC, leftMenuController: sideVC_L, rightMenuController: nil, leftMenuType: .SlideOver, rightMenuType: .SlideView)
            
            SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)
            
            SJSwiftSideMenuController.enableDimbackground = true
            SJSwiftSideMenuController.leftMenuWidth = 250
            //=======================================
            
            self.window?.rootViewController = mainVC
            self.window?.makeKeyAndVisible()
        }
        else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let sideMenuData = ["ALL TASK", "NOT ACCEPTED TASK", "MAP VIEW", "CALENDAR VIEW"]
            
            AppDelegate.sharedSegmentValue.sharedSegmentStringValue = 1
            
            let mainVC = SJSwiftSideMenuController()
            
            let sideVC_L : SideMenuViewController = (kStoryBoard.instantiateViewController(withIdentifier: kSideMenuViewController) as? SideMenuViewController)!
            sideVC_L.menuItems = (sideMenuData as NSArray?)!
            
            let rootVC = kStoryBoard.instantiateViewController(withIdentifier: kAdminUserListViewController) as! AdminUserListViewController
            
            SJSwiftSideMenuController.setUpNavigation(rootController: rootVC, leftMenuController: sideVC_L, rightMenuController: nil, leftMenuType: .SlideOver, rightMenuType: .SlideView)
            
            SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)
            
            SJSwiftSideMenuController.enableDimbackground = true
            SJSwiftSideMenuController.leftMenuWidth = 250
            //=======================================
            
            self.window?.rootViewController = mainVC
            self.window?.makeKeyAndVisible()
        }
        
    }
    //
    
    // Logout
    func methodForLogout() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let objLoginViewController = kStoryBoard.instantiateViewController(withIdentifier: kViewController) as? ViewController
        let loginNav = UINavigationController(rootViewController: objLoginViewController!)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = loginNav
        self.window?.makeKeyAndVisible()
    }
    //
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "OpenServiceCall")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

