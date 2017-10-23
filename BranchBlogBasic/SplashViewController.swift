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
            var blogs = [BlogData]()
            for jsonblob in jsonvalue as! Array<Any> {
                let id =  ((jsonblob as AnyObject)["id"] as! NSNumber).stringValue
                let date = (jsonblob as AnyObject)["date"] as! String
                let link = (jsonblob as AnyObject)["link"] as! String
                let title = ((jsonblob as AnyObject)["title"] as AnyObject)["rendered"] as! String
                let raw_description = ((jsonblob as AnyObject)["excerpt"] as AnyObject)["rendered"] as! String
                let description = raw_description.replacingOccurrences(of:"<[^>]+>", with: "", options: .regularExpression, range: nil)
                let content = ((jsonblob as AnyObject)["content"] as AnyObject)["rendered"] as! String
                let photo_url = (((((((jsonblob as AnyObject)["_embedded"] as AnyObject) ["wp:featuredmedia"] as! Array<Any>)[0] as AnyObject) ["media_details"] as AnyObject)["sizes"] as AnyObject) ["medium_large"] as AnyObject)["source_url"] as! String
//                print("\(#function) @@@@@ \(content)")
                let author_url = ((((jsonblob as AnyObject)["_links"] as AnyObject)["author"]as! Array<Any>)[0] as AnyObject)["href"] as! String
            
                guard let blog = BlogData(id: id, date: date, title: title, authorurl: author_url, photourl: photo_url, blog_description: description, blog_content: content, link: link ) else {
                    fatalError("Unable to instantiate BlogData")
                }
                blogs.append(blog)
            }
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
