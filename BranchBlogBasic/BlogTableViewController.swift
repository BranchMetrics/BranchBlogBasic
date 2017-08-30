//
//  ViewController.swift
//  BranchBlogBasic
//
//  Created by agrim on 8/14/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit

class BlogTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Mark: Properties
    var blogs = [BlogData]()
    let blogview_segue = "BlogViewSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBlog()
    }
    
    // Mark: Private methods
    private func loadBlog() {
        
        var placeholder_image = UIImage(named: "Branch_logo")

        // Sample Blogs
        
        //Blog 1
        var title = "How PregBuddy Used Branch to Link Between Messenger Bot and Android App"
        var image_url = "https://1yjmqg26uh9k15zq0o1pderc-wpengine.netdna-ssl.com/wp-content/uploads/2017/08/image2-2-1024x664.png"
        let url = URL(string: image_url)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                do {
                    if data != nil {
                        placeholder_image = UIImage(data:data as Data)
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
        var id = "2591"
        var author = "Alex Austin"
        var blog_description = "PregBuddy is an integrated health and wellness platform supporting women during their pregnancies. They offer personalized healthcare via peer support, organized information, expert access for nutrition, fitness and emotional advice"
        var jscript_date = "2017-08-11T08:56:01"
        var link = "https://blog.branch.io/how-pregbuddy-used-branch-to-link-between-messenger-bot-and-android-app/"
        
        guard let blog1 = BlogData(title: title, author: author, photo: placeholder_image, blog_description: blog_description,id: id,date: jscript_date,link: link ) else {
                    fatalError("Unable to instantiate BlogData")
        }
//        
//        //Blog 2
//        title = "The Ultimate Guide to Branch Products"
//        image_url = "https://blog.branch.io/wp-content/uploads/2017/08/image9.png"
//        url = NSURL(string:image_url)
//        data = NSData(contentsOf:url! as URL)
//        if data != nil {
//            placeholder_image = UIImage(data:data! as Data)
//        }
//        id = "2578"
//        jscript_date = "2017-08-08T09:01:28"
//        blog_description = "If you’ve heard of Branch, you probably know we have been providing deep links to developers and marketers on mobile for years now. Branch has grown quite a bit since"
//        link = "https://blog.branch.io/the-ultimate-guide-to-branch-products/"
//        
//        guard let blog2 = BlogData(title: title, photo: placeholder_image, blog_description: blog_description,id: id,date: jscript_date,link: link ) else {
//            fatalError("Unable to instantiate BlogData")
//        }
//        
//        //Blog 3
//        title = "Deep Linking or Organic Search Attribution: Can You Have Both?"
//        image_url = "https://blog.branch.io/wp-content/uploads/2017/08/image2.png"
//        url = NSURL(string:image_url)
//        data = NSData(contentsOf:url! as URL)
//        if data != nil {
//            placeholder_image = UIImage(data:data! as Data)
//        }
//        id = "2572"
//        jscript_date = "2017-08-03T11:12:11"
//        blog_description = "According to a report from Google last August, more than 60% of searches now occur on a mobile device, bringing the estimated volume of monthly mobile searches to 50 billion."
//        link = "https://blog.branch.io/deep-linking-or-organic-search-attribution-can-you-have-both/"
//        
//        guard let blog3 = BlogData(title: title, photo: placeholder_image, blog_description: blog_description,id: id,date: jscript_date,link: link ) else {
//            fatalError("Unable to instantiate BlogData")
//        }
        
        //Blog 4
//        title = "And the Winners of the Mobile Growth Stories Challenge Are…"
//        image_url = "https://blog.branch.io/wp-content/uploads/2017/08/image4-1.png"
//        url = NSURL(string:image_url)
//        data = NSData(contentsOf:url! as URL)
//        if data != nil {
//            placeholder_image = UIImage(data:data! as Data)
//        }
//        id = "2553"
//        jscript_date = "2017-08-01T10:13:56"
//        blog_description = "The wait is over! After reviewing all of the submissions to our Mobile Growth Stories Challenge, it’s time to announce the winners! Our judging panel (below) were impressed by the"
//        link = "https://blog.branch.io/and-the-winners-of-the-mobile-growth-stories-challenge-are/"
//        
//        guard let blog4 = BlogData(title: title, photo: placeholder_image, blog_description: blog_description,id: id,date: jscript_date,link: link ) else {
//            fatalError("Unable to instantiate BlogData")
//        }
//        
//        //Blog 5
//        title = "Mobile Growth in Review: Toronto!"
//        image_url = "https://blog.branch.io/wp-content/uploads/2017/08/Image-uploaded-from-iOS-7.jpg"
//        url = NSURL(string:image_url)
//        data = NSData(contentsOf:url! as URL)
//        if data != nil {
//            placeholder_image = UIImage(data:data! as Data)
//        }
//        id = "2561"
//        jscript_date = "2017-08-01T09:31:45"
//        blog_description = "What do you get when you mix Toronto, Helen Ouyang (Virgin Mobile), Alex Potichnyj (Checkout51), Jonathan Buccella (The Working Group), and mobile growth? Something really, really awesome. Don’t believe us?"
//        link = "https://blog.branch.io/mobile-growth-in-review-toronto/"
//        
//        guard let blog5 = BlogData(title: title, photo: placeholder_image, blog_description: blog_description,id: id,date: jscript_date,link: link ) else {
//            fatalError("Unable to instantiate BlogData")
//        }
//        
//        //Blog 6
//        title = "The Click to Install Benchmark Study of Over 10 Million App Installs"
//        image_url = "https://blog.branch.io/wp-content/uploads/2017/07/imac-apple-mockup-app-38544.jpeg"
//        url = NSURL(string:image_url)
//        data = NSData(contentsOf:url! as URL)
//        if data != nil {
//            placeholder_image = UIImage(data:data! as Data)
//        }
//        id = "2541"
//        jscript_date = "2017-07-31T10:27:00"
//        blog_description = "The success of a mobile app begins with user acquisition. While app marketers and developers have a plethora of paid options to grow their user base, finding the right startin"
//        link = "https://blog.branch.io/the-click-to-install-benchmark-study-of-over-10-million-app-installs/"
//        
//        guard let blog6 = BlogData(title: title, photo: placeholder_image, blog_description: blog_description,id: id,date: jscript_date,link: link ) else {
//            fatalError("Unable to instantiate BlogData")
//        }
//        
//        //Blog 7
//        title = "Branch Product Updates: July 2017"
//        image_url = "https://blog.branch.io/wp-content/uploads/2017/07/image1-2.png"
//        url = NSURL(string:image_url)
//        data = NSData(contentsOf:url! as URL)
//        if data != nil {
//            placeholder_image = UIImage(data:data! as Data)
//        }
//        id = "2534"
//        jscript_date = "2017-07-26T12:33:16"
//        blog_description = "The theme of July is channel improvements. A lot of our energy was devoted to making sure the channels we already support continue to receive tremendous attention and steady improvements"
//        link = "https://blog.branch.io/branch-product-updates-july-2017/"
//        
//        guard let blog7 = BlogData(title: title, photo: placeholder_image, blog_description: blog_description,id: id,date: jscript_date,link: link ) else {
//            fatalError("Unable to instantiate BlogData")
//        }
//        
//        //Blog 8
//        title = "How Marketers Can Deep Link from Social Media"
//        image_url = "https://blog.branch.io/wp-content/uploads/2017/07/Screen-Shot-2017-07-18-at-4.48.19-PM.png"
//        url = NSURL(string:image_url)
//        data = NSData(contentsOf:url! as URL)
//        if data != nil {
//            placeholder_image = UIImage(data:data! as Data)
//        }
//        id = "2502"
//        jscript_date = "2017-07-18T16:50:28"
//        blog_description = "Here’s the thing about deep linking across social media platforms: you probably understand more about its intricacies than you’d expect. At its core, deep linking provides users with access to"
//        link = "https://blog.branch.io/how-marketers-can-deep-link-from-social-media/"
//        
//        guard let blog8 = BlogData(title: title, photo: placeholder_image, blog_description: blog_description,id: id,date: jscript_date,link: link ) else {
//            fatalError("Unable to instantiate BlogData")
//        }
        
        blogs = [blog1]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BlogDataTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BlogDataTableViewCell  else {
            fatalError("The dequeued cell is not an instance of BlogDataTableViewCell.")
        }
        
        let blog_value = blogs[indexPath.row]
        
        cell.blogImage.image = blog_value.photo
        cell.blogTitle.text = blog_value.title
        cell.blogDescription.text = blog_value.blog_description
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let blog_value = blogs[indexPath.row]
        self.performSegue(withIdentifier: blogview_segue, sender:blog_value)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == blogview_segue {
            if let nextVC = segue.destination as? BlogViewController {
                nextVC.blog_data = sender as? BlogData
            }
        }
    }
    
//    func makePostRequest() {
//        var request = URLRequest(url: URL(string: "https://blog.branch.io/wp-json/wp/v2/posts")!)
//        request.httpMethod = "GET"
//        var response_string: String?
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                //check for fundamental networking error
//                print("error=\(String(describing: error))")
//                return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                //check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(String(describing: response))")
//            }
//            
//            let responseString = String(data: data, encoding: .utf8)
//            response_string = responseString!
//            print("responseString = \(String(describing: responseString))")
//            self.convertToDictionary(text: responseString!)
//        }
//        task.resume()
//    }
//    
//    func convertToDictionary(text: String) {
//        if let data = text.data(using: .utf8) {
//            do {
//                 try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }

}

