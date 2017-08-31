//
//  BlogCollectionViewController.swift
//  BranchBlogBasic
//
//  Created by agrim on 8/30/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BlogCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    fileprivate let reuseIdentifier = "BlogDataCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 1.0, bottom: 10.0, right: 1.0)
    fileprivate let itemsPerRow: CGFloat = 2
    var blogs = [BlogData]()
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return blogs.count
    }
    
    //3
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath)
        cell.backgroundColor = UIColor.black
        // Configure the cell
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout functions
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left

    }
}
