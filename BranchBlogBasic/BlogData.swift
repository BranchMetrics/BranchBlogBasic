//
//  BlogData.swift
//  BranchBlogBasic
//
//  Created by agrim on 8/15/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit

class BlogData: NSObject {
    
    //MARK: Properties
    var title: String?
    var photo: UIImage?
    var photourl: String?
    var blog_description: String?
    var id: String?
    var date: String?
    var link: String?
    
    struct PropertyKey {
        static let title = "name"
        static let photo = "photo"
    }
    
    init?(title: String, photo: UIImage?, blog_description: String,id: String,date: String,link: String ) {
        
        if title.isEmpty || id.isEmpty || link.isEmpty {
            return nil;
        }
        
        self.title = title
        self.photo = photo
        self.blog_description = blog_description
        self.id = id
        self.date = date
        self.link = link
    }
    
    init?(title: String, photourl: String?, blog_description: String,id: String,date: String,link: String ) {
        
        if title.isEmpty || id.isEmpty || link.isEmpty {
            return nil;
        }
        
        self.title = title
        self.photourl = photourl
        let url = NSURL(string:self.photourl!)
        let data = NSData(contentsOf:url! as URL)
        if data != nil {
            photo = UIImage(data:data! as Data)
        }
        self.blog_description = blog_description
        self.id = id
        self.date = date
        self.link = link
    }
}
