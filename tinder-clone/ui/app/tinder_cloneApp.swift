//
//  tinder_cloneApp.swift
//  tinder-clone
//
//  Created by Kevin and Kyle Tran on 1/1/22.
//

//import SwiftUI
//import Firebase
//import GoogleSignIn
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
//      FirebaseApp.configure()
//    FirebaseConfiguration.shared.setLoggerLevel(.min)
//        // 1
//        UNUserNotificationCenter.current().delegate = self
//        // 2
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(
//          options: authOptions) { _, _ in }
//        // 3
//        application.registerForRemoteNotifications()
//        Messaging.messaging().delegate = self
//
//      return true
//    }
//
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
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
//}
//
//extension AppDelegate: MessagingDelegate {
//  func messaging(
//    _ messaging: Messaging,
//    didReceiveRegistrationToken fcmToken: String?
//  ) {
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

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      FirebaseApp.configure()
      return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}
