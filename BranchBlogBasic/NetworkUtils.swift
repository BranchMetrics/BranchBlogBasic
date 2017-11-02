//
//  NetworkUtils.swift
//  BranchBlogBasic
//
//  Created by agrim on 8/29/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit

class NetworkUtils: NSObject {

    class func makeNetworkRequests(url: URL, closure: @escaping (_ jsonvalue: Any, _ errorvalue: NSError?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if data != nil {
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                closure(json as Any,error as NSError?)
            } else {
                let json = {};
                closure(json,error! as NSError)
            }
        }
        task.resume()
    }
    
    class func makeNetworkRequestsForImages(url: URL?, closure: @escaping (_ image: UIImage,_ error: NSError?) -> Void) {
        if url == nil {
            let image = UIImage(named: "Branch_logo")
            closure(image!,nil)
        } else {
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if data != nil {
                    let photo = UIImage(data:data!)
                    closure(photo!,error as NSError?)
                } else {
                    let photo = UIImage()
                    closure(photo,error! as NSError)
                }
            }
            task.resume()
        }
    }
    
    class func handleBlogData(_ jsonValue: Any) -> [BlogData]{
        var blogs = [BlogData]()
        guard let json = jsonValue as? Array<Any> else {
            return blogs
        }
        for jsonblob in json {
            let id =  ((jsonblob as AnyObject)["id"] as! NSNumber).stringValue
            let date = (jsonblob as AnyObject)["date"] as! String
            let link = (jsonblob as AnyObject)["link"] as! String
            let title = ((jsonblob as AnyObject)["title"] as AnyObject)["rendered"] as! String
            
            let raw_description = ((jsonblob as AnyObject)["excerpt"] as AnyObject)["rendered"] as! String
            let description = raw_description.replacingOccurrences(of:"<[^>]+>", with: "", options: .regularExpression, range: nil)
            let content = ((jsonblob as AnyObject)["content"] as AnyObject)["rendered"] as! String
            var photo_url:String = ""
            if let featuredMedia = (((jsonblob as AnyObject)["_embedded"] as AnyObject) ["wp:featuredmedia"] as? Array<Any>) {
                if let medLarge = ((((featuredMedia[0] as AnyObject) ["media_details"] as AnyObject)["sizes"] as AnyObject) ["medium_large"] as AnyObject)["source_url"] as? String {
                    photo_url = medLarge
                } else if let med = ((((featuredMedia[0] as AnyObject) ["media_details"] as AnyObject)["sizes"] as AnyObject) ["medium"] as AnyObject)["source_url"] as? String {
                    photo_url = med
                }
            }
            var authName = ""
//            let author = (((jsonblob as AnyObject)["_embedded"] as AnyObject) ["author"] as AnyObject)["name"] as? String
            if let authorArray = (((jsonblob as AnyObject)["_embedded"] as AnyObject) ["author"] as? Array<Any>) {
                if let name = (authorArray[0] as AnyObject) ["name"] as? String {
                    print("***** \(name)")
                    authName = name
                }
            }
            
//            let author_url = ((((jsonblob as AnyObject)["_links"] as AnyObject)["author"]as! Array<Any>)[0] as AnyObject)["href"] as! String
            
            guard let blog = BlogData(id: id, date: date, title: title, authorurl: authName, photourl: photo_url, blog_description: description, blog_content: content, link: link ) else {
                fatalError("Unable to instantiate BlogData")
            }
            blogs.append(blog)
        }
        return blogs
        
    }
    
    class func handleCategoryData(_ jsonValue: Any) -> [Category]{
        var categories = [Category]()
        for jsonblob in jsonValue as! Array<Any> {
            let id =  ((jsonblob as AnyObject)["id"] as! NSNumber).stringValue
            let name = (jsonblob as AnyObject)["name"] as! String
            let count = (jsonblob as AnyObject)["count"] as! Int
            
            guard let category = Category(id: id, name: name, count: count) else {
                fatalError("Unable to instantiate Category")
            }
            categories.append(category)
        }
        return categories
        
    }
}
