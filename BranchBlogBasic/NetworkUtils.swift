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
}
