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
    var branchUniversalObject: BranchUniversalObject!
    let utm_params: String = "?utm_medium=app&utm_source=branch-blog-app-ios"
    var id:String?
    
    @IBOutlet weak var BlogWebView: UIWebView!

    @IBAction func shareLink(_ sender: UIBarButtonItem) {
        
        Branch.getInstance().userCompletedAction("Share_blog")
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "app_sharing"
        linkProperties.channel = "Facebook"
        linkProperties.campaign = "user_referral"
        linkProperties.addControlParam("$ios_url", withValue: (blog_data?.link)!+utm_params)
        linkProperties.addControlParam("$android_url", withValue: (blog_data?.link)!+utm_params)
        linkProperties.addControlParam("$desktop_url", withValue: (blog_data?.link)!+utm_params)
        linkProperties.addControlParam("$fallback_url", withValue: (blog_data?.link)!+utm_params)
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
    
    public func reload() {
        let unwrap_url = URLRequest(url: URL(string: (blog_data?.link)!)!)
        BlogWebView.loadRequest(unwrap_url)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if blog_data != nil {
            loadBlogPost()
        } else {
            if let id = id{
                let url: URL = URL(string: "https://blog.branch.io/wp-json/wp/v2/posts?id=\(id)")!
                NetworkUtils.makeNetworkRequests(url:url, closure:getBlogPosts )
            }
        }
    }
    
    func getBlogPosts(_ jsonvalue: Any,_ error: Error?) {
        if error == nil {
            loadBlogPost()
        } else {
            print(jsonvalue)
        }
    }
    
    func loadBlogPost(){
        self.navigationItem.title = blog_data?.title!
        let newcontent = "<html><head><meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0'><link rel='stylesheet' id='rppWidgetCss-group-css' href='https://1yjmqg26uh9k15zq0o1pderc-wpengine.netdna-ssl.com/wp-content/plugins/bwp-miflipboardnify/min/?f=wp-content/plugins/related-posts/style/widget.css,wp-content/plugins/exit-popup/css/exit-popup.css,wp-content/plugins/social-pug/assets/css/style-frontend.css,wp-content/plugins/cta/shared/shortcodes/css/frontend-render.css,wp-content/themes/salient/css/rgs.css,wp-content/themes/salient/css/font-awesome.min.css,wp-content/themes/salient-child/style.css,wp-content/themes/salient/css/prettyPhoto.css,wp-content/themes/salient/css/responsive.css,wp-content/themes/salient/css/ascend.css,wp-content/plugins/enlighter/resources/EnlighterJS.min.css&amp;ver=1497973011' type='text/css' media='all'> <link rel='stylesheet' id='options_typography_OpenSans_ext-css' href='https://fonts.googleapis.com/css?family=Open+Sans%3A300%2C400%2C600%2C700&amp;subset=latin%2Clatin-ext' type='text/css' media='all'><style type='text/css'>body {font-family: Helvetica; color:#1e1e1e;} .title{font-size:1.25em; margin:1.25em 0 0 0; color: #1cadce; text-align:center;} .author{ font-size: 0.8em; text-align:center; font-weight:normal; color: #888888; margin: 0.7em 0;} img{ max-width: 100% !important; height: auto !important; }</style></head> " +
            "<html><body><div class='container main-content'><h1 class='title'>\((blog_data?.title!)!)</h1>" +
            "<h3 class='author'>By \((blog_data?.author!)!)</h3>" +
            (blog_data?.blog_content!)! + "</div></div></body></html>"
        
        
        BlogWebView.loadHTMLString(newcontent, baseURL: nil)
        
        //Create a BUO on page load
        branchUniversalObject = BranchUniversalObject(canonicalIdentifier: (blog_data?.link)!)
        branchUniversalObject.title = blog_data?.title
        branchUniversalObject.canonicalUrl = blog_data?.link
        branchUniversalObject.contentDescription = blog_data?.blog_description
        branchUniversalObject.imageUrl = blog_data?.photourl
        branchUniversalObject.addMetadataKey("id", value: (blog_data?.id) ?? "")
        branchUniversalObject.addMetadataKey("date", value: (blog_data?.date) ?? "")
        branchUniversalObject.addMetadataKey("author", value: (blog_data?.author) ?? "")
        branchUniversalObject.addMetadataKey("content", value: (blog_data?.blog_content) ?? "")
        branchUniversalObject.addMetadataKey("blog_link", value: ((blog_data?.link)!+utm_params))
        branchUniversalObject.automaticallyListOnSpotlight = true
        branchUniversalObject.userCompletedAction(BNCRegisterViewEvent)
    }
    
}
