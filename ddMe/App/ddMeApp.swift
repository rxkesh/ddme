//
//  ddMeApp.swift
//  ddMe
//
//  Created by Rakesh Pillai on 7/1/23.
//
/*
   Description:
   App launch file, has appdelegate which is used to handle application lifecycle events.
   
   Last Modified:
   7/1/23
   
   Version:
   1.0
   
   Notes:
   - I use it to handle push notifications and remote notifications for auth
   - I also use it for handling the URL scheme which is what allows for recaptcha for auth
*/
import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      print("SwiftUI_2_Lifecycle_PhoneNumber_AuthApp application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
      return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("\(#function)")
      Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      print("\(#function)")
      if Auth.auth().canHandleNotification(notification) {
        completionHandler(.noData)
        return
      }
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      print("\(#function)")
      if Auth.auth().canHandle(url) {
        return true
      }
      return false
    }
  }

@main
struct ddMeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthViewModel()
    @StateObject var driverViewModel = DriverViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(driverViewModel)
        }
    }
}
