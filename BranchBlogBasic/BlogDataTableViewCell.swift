//
//  BlogDataTableViewCell.swift
//  BranchBlogBasic
//
//  Created by agrim on 8/15/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit

class BlogDataTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var blogImage: UIImageView!
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogDescription: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
