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
    var blog_content: String?
    var author: String?
    var authorurl:String?
    var id: String?
    var date: String?
    var link: String?
    
    struct PropertyKey {
        static let title = "name"
        static let photo = "photo"
    }
    
    init?(title: String, author: String, photo: UIImage?, blog_description: String, blog_content: String, id: String,date: String,link: String ) {
        
        if title.isEmpty || id.isEmpty || link.isEmpty {
            return nil;
        }
        
        self.title = title
        self.author = author
        self.photo = photo
        self.blog_description = blog_description
        self.id = id
        self.blog_content = blog_content
        self.date = date
        self.link = link
    }
    
    init?(id: String?,
          date: String?,
          title: String?,
          author: String?,
          photourl: String?,
          blog_description: String?,
          blog_content:String?,
          link: String ) {
        
        if link.isEmpty {
            return nil;
        }
        
        self.title = title
        self.author = author
        self.photourl = photourl
        self.blog_description = blog_description
        self.blog_content = blog_content
        self.id = id
        self.date = date
        self.link = link
    }
    
    func addAuthor(_ author:String) {
        self.author = author
    }
    
    func addImage(image:UIImage) {
        self.photo = image
    }
}
