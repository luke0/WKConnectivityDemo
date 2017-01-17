//
//  AppDelegate.swift
//  WK_DataTransfer
//
//  Created by Luke Inger on 13/01/2017.
//  Copyright © 2017 Luke Inger. All rights reserved.
//

import UIKit
import WatchKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var DTWKSession:WCSession?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if WCSession.isSupported() {
            DTWKSession = WCSession.default()
            DTWKSession?.delegate = self
            DTWKSession?.activate()
        }
        
        return true
    }

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
    }
    
}

extension AppDelegate: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == WCSessionActivationState.activated {
            print("App Session Activated")
        } else if activationState == WCSessionActivationState.inactive {
            print("App Session Inactive")
        } else if activationState == WCSessionActivationState.notActivated {
            print("App Session Not Activate")
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        //Find the username values
        let user = message["User"]
        
        //Replicate an authentication (Would match to keychain normally)
        if let u = user as? String {
            if u == "Joe Bloggs" {
                
                var received:DTMessage = DTMessage()
                received = received.fromDict(dict: message)
                
                for message in received.Values {
                    if let msg = message as? DTMessageItem {
                        if let t = msg.title, let v = msg.value {
                            print("Watch message \(t) \(v)")
                        }
                    }
                }
                
                //Build the response - Data could be from anywhere
                let replyMessage:DTMessage = DTMessage()
                replyMessage.addItem(title: "User", value: u)
                replyMessage.addItem(title: "Age", value: "65")
                replyMessage.addItem(title: "Gender", value: "Male")
                
                // Using the block to send back a message to the Watch
                replyHandler(replyMessage.toDict())
                
            }
        } else {
            //Authentication Failed -- DO SOMETHING!!
        }

    }
}
