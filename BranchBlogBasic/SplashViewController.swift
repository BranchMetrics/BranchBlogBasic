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
    let url: URL = URL(string: "https://blog.branch.io/wp-json/wp/v2/posts")!
    let bloglist_segue = "pushToBlogList"
    
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
            if let nextVC = segue.destination as? BlogTableViewController {
                nextVC.blogs = (sender as? [BlogData])!
            }
        }
    }
    
    func prepareBlogData(_ jsonvalue: Any) {
        if jsonvalue is Array<Any> {
            var blogs = [BlogData]()
            for jsonblob in jsonvalue as! Array<Any> {
                let id =  ((jsonblob as AnyObject)["id"] as! NSNumber).stringValue
                let date = (jsonblob as AnyObject)["date"] as! String
                let link = (jsonblob as AnyObject)["link"] as! String
                let title = ((jsonblob as AnyObject)["title"] as AnyObject)["rendered"] as! String
                let description = ((jsonblob as AnyObject)["excerpt"] as AnyObject)["rendered"] as! String
                let photo_url = ((((jsonblob as AnyObject)["_links"] as AnyObject)["wp:featuredmedia"] as! Array<Any>)[0] as AnyObject)["href"] as! String
                let author_url = ((((jsonblob as AnyObject)["_links"] as AnyObject)["author"]as! Array<Any>)[0] as AnyObject)["href"] as! String
                guard let blog = BlogData(id: id, date: date, title: title, authorurl: author_url, photourl: photo_url, blog_description: description ,link: link ) else {
                    fatalError("Unable to instantiate BlogData")
                }
                NetworkUtils.makeNetworkRequests(url:URL(string:author_url)!, closure:{ (jsonreturned: Any) -> Void in
                    var author = ""
                    if !(jsonreturned is NSError) {
                        author = (jsonreturned as AnyObject)["name"] as! String
                    }
                    blog.addAuthor(author)
                    blogs.append(blog)
                    if(blogs.count == (jsonvalue as! Array<Any>).count) {
                        self.screenloader.stopAnimating()
                        self.performSegue(withIdentifier: self.bloglist_segue, sender:blogs)
                    }
                })
            }
        } else {
            screenloader.stopAnimating()
            alertLabel.text = "Your device appears to be offline."
            alertLabel2.text = "Double tap to reload"
            print(jsonvalue)
        }
    }
}
