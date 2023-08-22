//
//  Nano2App.swift
//  Nano2
//
//  Created by ChoiYujin on 8/17/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Nano2App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @AppStorage("uid") var uid = ""
    @StateObject var fireStoreViewModel: FireStoreViewModel = FireStoreViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if uid == "" {
                    ContentView()
                } else {
                    TabBarView()
                        .environmentObject(fireStoreViewModel)
                }
                
            }
        }
    }
}

public func Log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcName: String = #function) {
#if DEBUG
    if let obj = object {
        print("\(Date()) \(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : \(obj)")
    } else {
        print("\(Date()) \(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : nil")
    }
#endif
}
