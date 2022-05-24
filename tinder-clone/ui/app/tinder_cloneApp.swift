//
//  tinder_cloneApp.swift
//  tinder-clone
//
//  Created by Kevin and Kyle Tran on 1/1/22.
//
//
//import SwiftUI
//import Firebase
//import GoogleSignIn
//import FirebaseMessaging
//
//@main
//struct tinder_cloneApp: App {
//
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//
//    @StateObject var authViewModel = AuthViewModel()
//    @StateObject var firestoreViewModel = FirestoreViewModel()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environmentObject(authViewModel)
//                .environmentObject(firestoreViewModel)
//        }
//    }
//}
//
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//  var window: UIWindow?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
//
//        FirebaseConfiguration.shared.setLoggerLevel(.min)
//
//
//        // 1
//        UNUserNotificationCenter.current().delegate = self
//        // 2
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(
//          options: authOptions) { _, _ in }
//        // 3
//        application.registerForRemoteNotifications()
//        Messaging.messaging().delegate = self
//        //permission for user
//
//
//             let center = UNUserNotificationCenter.current()
//
//             center.requestAuthorization(options: [.alert, .sound])
//             { (granted, error) in
//
//             }
//
//
//
//
//          //Notification Content Testing
//             let content = UNMutableNotificationContent()
//             content.title = "Hello User"
//             content.body = "joobie is the winner here"
//
//             //Notification trigger
//             let date = Date().addingTimeInterval(10)
//
//             let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//
//             let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//
//             //Step 4: Getting requests
//
//             let uuidString = UUID().uuidString
//             let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
//
//             //regier for requester
//             center.add(request) { (error) in
//                 //error checker
//             }
//
//
//      return true
//    }
//
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//
//      return GIDSignIn.sharedInstance.handle(url)
//    }
//}
//extension AppDelegate: UNUserNotificationCenterDelegate {
//  func userNotificationCenter(
//    _ center: UNUserNotificationCenter,
//    willPresent notification: UNNotification,
//    withCompletionHandler completionHandler:
//    @escaping (UNNotificationPresentationOptions) -> Void
//  ) {
//    completionHandler([[.banner, .sound]])
//  }
//
//  func userNotificationCenter(
//    _ center: UNUserNotificationCenter,
//    didReceive response: UNNotificationResponse,
//    withCompletionHandler completionHandler: @escaping () -> Void
//  ) {
//    completionHandler()
//  }
//    func application(
//      _ application: UIApplication,
//      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
//    ) {
//      Messaging.messaging().apnsToken = deviceToken
//    }
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register with push")
//    }
//}
//
//extension AppDelegate: MessagingDelegate {
//  func messaging(
//    _ messaging: Messaging,
//    didReceiveRegistrationToken fcmToken: String?
//  ) {
//      print("Device Token:", fcmToken)
//      print("end ")
//    let tokenDict = ["token": fcmToken ?? ""]
//    NotificationCenter.default.post(
//      name: Notification.Name("FCMToken"),
//      object: nil,
//      userInfo: tokenDict)
//  }
//}
import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseMessaging
import UserNotifications

@main
struct tinder_cloneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject var authViewModel = AuthViewModel()
    @StateObject var firestoreViewModel = FirestoreViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(firestoreViewModel)
        }
    }
}
//Function Clear: no token issues
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      FirebaseApp.configure()

                Messaging.messaging().delegate = self

                if #available(iOS 10.0, *) {
                  // For iOS 10 display notification (sent via APNS)
                  UNUserNotificationCenter.current().delegate = self

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
      return true
    }
    //Function Clear: no token issues-90% sure
    //it is checking for background calls; works
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

          if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
          }

          print(userInfo)

          completionHandler(UIBackgroundFetchResult.newData)
        }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }

    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .badge, .sound]])
  }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //WE WERENT ASSIGNING THE FCM TOKEN WITH THE DEVICE TOKEN
        Messaging.messaging().apnsToken = deviceToken

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID from userNotificationCenter didReceive: \(messageID)")
    }

    print(userInfo)

    completionHandler()
  }
}
