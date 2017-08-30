//
//  NetworkUtils.swift
//  BranchBlogBasic
//
//  Created by agrim on 8/29/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit

class NetworkUtils: NSObject {

    class func makeNetworkRequests(url: URL, closure: @escaping (_ jsonvalue: Any) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if data != nil {
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                closure(json as! Array<Any>)
            } else {
                closure(error!)
            }
        }
        task.resume()
    }
}
