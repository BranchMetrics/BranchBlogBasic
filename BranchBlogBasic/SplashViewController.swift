//
//  SplashViewController.swift
//  BranchBlogBasic
//
//  Created by agrim on 8/28/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var screenloader: UIActivityIndicatorView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var alertLabel2: UILabel!
    let url: URL = URL(string: "https://blog.branch.io/wp-json/wp/v2/posts?_embed")!
    let bloglist_segue = "pushToBlogList"
    let show_webview = "showWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //making blog post call
        NetworkUtils.makeNetworkRequests(url:url, closure:prepareBlogData )
        screenloader.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        screenloader.hidesWhenStopped = true
        screenloader.startAnimating()
        alertLabel.text=""
        alertLabel2.text=""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch =  touches.first!
        if (touch.tapCount == 2) {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch =  touches.first!
        if (touch.tapCount == 2) {
            screenloader.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            screenloader.hidesWhenStopped = true
            screenloader.startAnimating()
            alertLabel.text=""
            alertLabel2.text=""
            NetworkUtils.makeNetworkRequests(url:url, closure:prepareBlogData )
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == self.bloglist_segue {
            if let nextVC = segue.destination as? BlogCollectionViewController {
                nextVC.blogs = (sender as? [BlogData])!
            }
        }
        if segue.identifier == self.show_webview {
            if let nextVC = segue.destination as? BlogViewController {
                nextVC.blog_data = (sender as? BlogData)!
            }
        }
    }
    
    func prepareBlogData(_ jsonvalue: Any,_ error: Error?) {
        if error == nil {
            let blogs = NetworkUtils.handleBlogData(jsonvalue)
            self.screenloader.stopAnimating()
            self.performSegue(withIdentifier: self.bloglist_segue, sender:blogs)
        } else {
            screenloader.stopAnimating()
            alertLabel.text = "Your device appears to be offline."
            alertLabel2.text = "Double tap to reload"
            print(jsonvalue)
        }
    }
    func unwindFromBlogView(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("unwind back to the blog collection view")
    }
}
