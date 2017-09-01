//
//  BlogCollectionViewCell.swift
//  BranchBlogBasic
//
//  Created by agrim on 8/30/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit

class BlogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var BlogTitle: UILabel!
    var blog_data: BlogData?
    
    override var isSelected: Bool {
        didSet {
            self.BlogTitle.alpha = self.isSelected ? 1.0 : 0
            self.imageView.alpha = self.isSelected ? 0.3 : 1
        }
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        BlogTitle.textColor = UIColor.white
        isSelected = false
    }
}

