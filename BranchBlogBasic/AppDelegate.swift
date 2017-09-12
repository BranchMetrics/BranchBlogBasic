//
//  AppDelegate.swift
//  BranchBlogBasic
//
//  Created by agrim on 8/14/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit
import Branch

let themeColor = UIColor(red: 0.188, green: 0.212, blue: 0.329, alpha: 1.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var show_webview_directly = "showWebView"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window?.tintColor = themeColor
        
        Branch.getInstance().initSession(launchOptions: launchOptions) { params, error in
            print(params as? [String: AnyObject] ?? {})
            
            if error == nil && params?["+clicked_branch_link"] != nil && params?["blog_link"] != nil {
                guard let blog = BlogData(id: (params?["id"] as? String)!,
                                          date: (params?["date"] as? String),
                                          title: (params?["$og_title"] as? String),
                                          authorurl: (params?["authorurl"] as? String),
                                          photourl: (params?["$og_image_url"] as? String),
                                          blog_description: (params?["$og_description"] as? String),
                                          link: (params?["blog_link"] as? String)! )
                    else {
                    fatalError("Unable to instantiate BlogData")
                }
                var rootViewController = self.window!.rootViewController!;
                while ((rootViewController.presentedViewController) != nil) {
                    rootViewController = rootViewController.presentedViewController!
                }
                if(rootViewController.isKind(of: SplashViewController.self)){
                    rootViewController.performSegue(withIdentifier: "showWebView", sender: blog)
                } else if (rootViewController.isKind(of: BlogCollectionViewController.self)) {
                    rootViewController.performSegue(withIdentifier: "showWebView", sender: blog)
                } else {
                    (rootViewController as! BlogViewController).blog_data = blog
                    (rootViewController as! BlogViewController).reload()
                }
                
            } else if error == nil && params?["+clicked_branch_link"] != nil && params?["$canonical_url"] != nil{
                let canonical_url = (params?["$canonical_url"] as? String)!.replacingOccurrences(of: "test=true", with: "")
                guard let blog = BlogData(id: (params?["id"] as? String),
                                          date: (params?["date"] as? String),
                                          title: (params?["$og_title"] as? String),
                                          authorurl: (params?["authorurl"] as? String),
                                          photourl: (params?["$og_image_url"] as? String),
                                          blog_description: (params?["$og_description"] as? String),
                                          link: canonical_url )
                    else {
                        fatalError("Unable to instantiate BlogData")
                }
                var rootViewController = self.window!.rootViewController!;
                while ((rootViewController.presentedViewController) != nil) {
                    rootViewController = rootViewController.presentedViewController!
                }
                if(rootViewController.isKind(of: SplashViewController.self)){
                    rootViewController.performSegue(withIdentifier: "showWebView", sender: blog)
                } else if (rootViewController.isKind(of: BlogCollectionViewController.self)) {
                    rootViewController.performSegue(withIdentifier: "showWebView", sender: blog)
                } else {
                    (rootViewController as! BlogViewController).blog_data = blog
                    (rootViewController as! BlogViewController).reload()
                }
            } else {
                // load your normal view
            }
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

    // Respond to Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // pass the url to the handle deep link call
        Branch.getInstance().continue(userActivity)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // pass the url to the handle deep link call
        Branch.getInstance().application(app,
                                         open: url,
                                         options:options
        )
        
        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
        return true
    }

}

