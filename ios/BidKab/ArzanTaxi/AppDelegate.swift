//
//  AppDelegate.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/8/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import Firebase
import UserNotifications
import SVProgressHUD
import SwiftyJSON
import Alamofire

let defaults = UserDefaults.self
let indicator = SVProgressHUD.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SWRevealViewControllerDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    static var device_token: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Messaging.messaging().delegate = self
        FirebaseApp.configure()
        Socket.shared.connect()
        UNUserNotificationCenter.current().delegate = self
        if !UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            UserDefaults.standard.set("ru", forKey: "language")
        } else {
            UserDefaults.standard.set("ru", forKey: "language")
        }
        setupAppdelegate()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
//        if Messaging.messaging().fcmToken != nil {
//
//            let cityId = UserDefaults.standard.integer(forKey: "city_id")
//            print(cityId)
////            Messaging.messaging().subscribe(toTopic: "order_list_\(cityId)")
//            if let token = UserDefaults.standard.string(forKey: "token") {
//                Messaging.messaging().subscribe(toTopic: "topics/\(token)")
//            }
//
//            Messaging.messaging().subscribe(toTopic: "topics/notification_ios")
//
//        }

        return true
    }
    
    public func setupAppdelegate() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        UINavigationController().navigationController?.navigationBar.tintColor = .clear
        
        
        
        var navController = UINavigationController()
        if UserDefaults.standard.bool(forKey: "isUserInDriverMode") {
            let driverController = DriverHomeController()
            navController = UINavigationController(rootViewController: driverController)
        } else {
            let homeController = HomeViewController()
            navController = UINavigationController(rootViewController: homeController)
        }
        
        let leftMenuController = LeftMenuController()
        
        let sideMenuController = SWRevealViewController(rearViewController: leftMenuController, frontViewController: navController)
        sideMenuController?.delegate = self
        
//        let tutorialController = UINavigationController(rootViewController: SliderMenuViewController())
        let tutorialController = UINavigationController(rootViewController: ConfidentialViewController())
        var rootViewController : UIViewController?
        
//        rootViewController = sideMenuController
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            rootViewController = sideMenuController
        } else {
            rootViewController = tutorialController
            UserDefaults.standard.set("ru", forKey: "language")
        }
        
//        let userDefault = UserDefaults.standard
//        let dict = userDefault.dictionaryRepresentation()
//        dict.keys.forEach { (each) in
//            userDefault.removeObject(forKey: each)
//        }

        window?.rootViewController = rootViewController
        
        UINavigationBar.appearance().barTintColor = .white
        UIApplication.shared.isStatusBarHidden = true
        UINavigationBar.appearance().tintColor = .blue
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.blue]
//        UINavigationBar.appearance().color
        UINavigationBar.appearance().isTranslucent = false
        

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
            return
        }
        print("userinfo no completionHandler", userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        print("userInfo with completionHandler", userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
//        if Messaging.messaging().fcmToken != nil {
//
////            Messaging.messaging().subscribe(toTopic: "order_list_1")
//            if let token = UserDefaults.standard.string(forKey: "token") {
//                Messaging.messaging().subscribe(toTopic: "topics/\(token)")
//            }
//
//            Messaging.messaging().subscribe(toTopic: "topics/notification_ios")
//
//        }
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        AppDelegate.device_token = fcmToken

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Socket.shared.disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        Socket.shared.connect()
//        if !UserDefaults.standard.bool(forKey: "isUserInDriverMode") {
//
//        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        if !UserDefaults.standard.bool(forKey: "isUserInDriverMode") {
//            Socket.shared.connect()
//        }
        Socket.shared.connect()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Socket.shared.disconnect()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func revealController(_ revealController: SWRevealViewController!, willAdd viewController: UIViewController!, for operation: SWRevealControllerOperation, animated: Bool) {
        
    }
    
    func revealController(_ revealController: SWRevealViewController!, didAdd viewController: UIViewController!, for operation: SWRevealControllerOperation, animated: Bool) {
        
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("ios10 willPresent notification: ", userInfo)
        completionHandler([.alert, .badge, .sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        let json = JSON(userInfo)
        print("userinfo: \(json)")

        let type = json["gcm.notification.type"].string
        if let type = type {
            if type == "notification" {
                moveToNotification()
            } else if type == "taxi_orders" {
                setupAppdelegate()
            } else if type == "order_trade" {
                setupAppdelegate()
            }
        }

        let id = json["gcm.notification.user_id"].intValue
        
        showAlert(id: id)
        
        completionHandler()
    }

    private func moveToNotification(){
        let sideMenuController = SWRevealViewController(rearViewController: LeftMenuController(), frontViewController: UINavigationController(rootViewController: NotificationsViewController()))
        sideMenuController?.delegate = self
        self.window?.rootViewController = sideMenuController
    }

    private func showAlert(id : Int) {
        Alamofire.request(Constant.api.get_user + "\(id)").responseJSON { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    print("Get user: \(json)")
                    
                    if json["statusCode"].intValue == Constant.statusCode.success {
                        let surname = json["result"]["surname"].stringValue
                        let name = json["result"]["name"].stringValue
                        let phone = json["result"]["phone"].stringValue
                        let token = json["result"]["token"].stringValue
                        
                        let text = surname + " " + name + " " + phone + " " + .localizedString(key: "friend_text")
 
                        let alert = UIAlertController(title: .localizedString(key: "friend_label"), message: text, preferredStyle: .alert)
                        let yes = UIAlertAction(title: .localizedString(key: "yes"), style: .default, handler: { (action) in
                            self.acceptRequest(token: token)
                        })
                        let no = UIAlertAction(title: .localizedString(key: "no"), style: .cancel, handler: nil)
                        
                        alert.addAction(yes)
                        alert.addAction(no)
                        
                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func acceptRequest(token : String) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        Alamofire.request(Constant.api.accept_friend, method: .post, parameters: [ "token" : token, "user_id" : id ], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    print("Accept friend: \(json)")
                    
                    if json["statusCode "].intValue == Constant.statusCode.success {
                        indicator.showSuccess(withStatus: "Added")
                    } else {
                        indicator.showError(withStatus: "Error")
                    }
                }
            }
        }
    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
//    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
//        print("Firebase refresh registration token: \(fcmToken)")
//    }
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
//    }
//     [END ios_10_data_message]
}




