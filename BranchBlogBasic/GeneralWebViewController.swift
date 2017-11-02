//
//  GeneralWebViewController.swift
//  BranchBlogBasic
//
//  Created by Joseph Geraghty on 10/31/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit
import Branch

class GeneralWebViewController: UIViewController {
    
    //Mark: Properties
    var webOnlyLink: String?
    var branchUniversalObject: BranchUniversalObject!
    let utm_params: String = "?utm_medium=app&utm_source=branch-blog-app-ios"
    var id:String?
    
    @IBOutlet weak var GeneralWebView: UIWebView!
    
    @IBAction func shareLink(_ sender: UIBarButtonItem) {
        
        Branch.getInstance().userCompletedAction("Share_blog")
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "app_sharing"
        linkProperties.channel = "Facebook"
        linkProperties.campaign = "user_referral"
        linkProperties.addControlParam("$web_only", withValue: "true")
        linkProperties.addControlParam("$original_url", withValue: webOnlyLink!+utm_params)
        branchUniversalObject.showShareSheet(with: linkProperties,
                                             andShareText: "Check out this webpage!",
                                             from: self) { (activityType, completed) in
                                                if (completed) {
                                                    print(String(format: "Completed sharing to %@", activityType!))
                                                } else {
                                                    print("Link sharing cancelled")
                                                }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        if webOnlyLink != nil {
            let urlRequest = URLRequest(url: URL(string: webOnlyLink!)!)
            GeneralWebView.loadRequest(urlRequest)
        } else {
            //Should gracefully exit or show error
        }
    }
    
}

