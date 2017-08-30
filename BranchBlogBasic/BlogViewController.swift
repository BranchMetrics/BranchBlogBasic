//
//  BlogViewController.swift
//  BranchBlogBasic
//
//  Created by agrim on 8/15/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit
import Branch

class BlogViewController: UIViewController {
    
    //Mark: Properties
    var blog_data: BlogData?
    @IBOutlet weak var BlogWebView: UIWebView!
    @IBOutlet weak var Titlebar: UINavigationItem!
    @IBOutlet weak var ShareButton: UIBarButtonItem!

    @IBAction func shareLink(_ sender: UIBarButtonItem) {
        let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: (blog_data?.link)!)
        branchUniversalObject.title = blog_data?.title
        branchUniversalObject.contentDescription = blog_data?.blog_description
        branchUniversalObject.imageUrl = blog_data?.photourl
        branchUniversalObject.addMetadataKey("blog_link", value: (blog_data?.link)!)
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "app_sharing"
        linkProperties.channel = "Facebook"
        linkProperties.campaign = "user_referral"
        linkProperties.addControlParam("$ios_url", withValue: blog_data?.link)
        linkProperties.addControlParam("$android_url", withValue: blog_data?.link)
        linkProperties.addControlParam("$desktop_url", withValue: blog_data?.link)
        
        branchUniversalObject.showShareSheet(with: linkProperties,
                                             andShareText: "Check out this blog",
                                             from: self) { (activityType, completed) in
                                                if (completed) {
                                                    print(String(format: "Completed sharing to %@", activityType!))
                                                } else {
                                                    print("Link sharing cancelled")
                                                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let unwrap_url = URLRequest(url: URL(string: (blog_data?.link)!)!)
        BlogWebView.loadRequest(unwrap_url)
        Titlebar.title = blog_data?.title
    }
}