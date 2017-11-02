//
//  Category.swift
//  BranchBlogBasic
//
//  Created by Joseph Geraghty on 10/24/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import Foundation

class Category: NSObject {
    
    //MARK: Properties
    var id: String?
    var name: String?
    var count: Int?
    
    init?(id: String, name: String, count: Int) {
        
        if id.isEmpty || name.isEmpty {
            return nil;
        }
        
        self.id = id
        self.name = name
        self.count = count
    }
    
    init?(id: String?,
          name: String?,
          count: Int?) {
        
        if !(id != nil) {
            return nil;
        }
        
        self.id = id
        self.name = name
        self.count = count
    }
}
