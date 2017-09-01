//
//  BlogCollectionViewController.swift
//  BranchBlogBasic
//
//  Created by agrim on 8/30/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BlogCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    fileprivate let reuseIdentifier = "BlogDataCell"
    fileprivate let reuseHeaderIdentifier = "HeaderView"
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 10.0, right: 5.0)
    fileprivate let itemsPerRow: CGFloat = 2
    let show_webview = "showWebView"
    var blogs = [BlogData]()
    var largePhotoIndexPath: IndexPath? {
        didSet {
            var indexPaths = [IndexPath]()
            if let largePhotoIndexPath = largePhotoIndexPath {
                indexPaths.append(largePhotoIndexPath as IndexPath)
            }
            if let oldValue = oldValue {
                indexPaths.append(oldValue as IndexPath)
            }
            collectionView?.performBatchUpdates({
                self.collectionView?.reloadItems(at: indexPaths)
            }) { completed in
                if let largePhotoIndexPath = self.largePhotoIndexPath {
                    self.collectionView?.scrollToItem(
                        at: largePhotoIndexPath as IndexPath,
                        at: .centeredVertically,
                        animated: true)
                }
            }
        }
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        largePhotoIndexPath = largePhotoIndexPath == indexPath ? nil : indexPath
        return false
    }
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return blogs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! BlogCollectionViewCell
        
        guard indexPath == largePhotoIndexPath else {
            cell.backgroundColor = UIColor.black
            cell.imageView.image = blogs[(indexPath as NSIndexPath).row].photo
            cell.BlogTitle.text = blogs[(indexPath as NSIndexPath).row].title
            return cell
        }
        
        if indexPath == largePhotoIndexPath {
            cell.isSelected = !cell.isSelected
        }
        
        cell.backgroundColor = UIColor.black
        cell.imageView.image = blogs[(indexPath as NSIndexPath).row].photo
        cell.blog_data = blogs[(indexPath as NSIndexPath).row]
        cell.BlogTitle.text = blogs[(indexPath as NSIndexPath).row].title
        
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        gestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        gestureRecognizer.delegate = self as UIGestureRecognizerDelegate
        cell.addGestureRecognizer(gestureRecognizer)
        
        //Set a shadow
        let shadowPath = UIBezierPath(rect: cell.imageView.bounds).cgPath
        cell.imageView.layer.shadowColor = UIColor(white: 0.7, alpha: 0.7).cgColor
        cell.imageView.layer.shadowOffset = CGSize(width:3,height:3)
        cell.imageView.layer.shadowOpacity = 0.4
        cell.imageView.layer.masksToBounds = false
        cell.imageView.layer.shadowPath = shadowPath
        cell.imageView.layer.shadowRadius = 2
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func handleSwipe(gestureRecognizer: UIGestureRecognizer) {
        self.performSegue(withIdentifier: self.show_webview, sender:(gestureRecognizer.view as! BlogCollectionViewCell).blog_data)
    }
    
    //UICollectionViewDelegateFlowLayout functions
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == largePhotoIndexPath as IndexPath? {
            let photo = blogs[(indexPath as NSIndexPath).row].photo
            var size = collectionView.bounds.size
            size.height -= topLayoutGuide.length
            size.height -= (sectionInsets.top + sectionInsets.right)
            size.width -= (sectionInsets.left + sectionInsets.right)
            return self.sizeToFillWidthOfSize(photo!,size)
        }
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
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
    
    //Enlarging Image
    func sizeToFillWidthOfSize(_ photo:UIImage,_ size:CGSize) -> CGSize {
        
        let imageSize = photo.size
        var returnSize = size
        
        let aspectRatio = imageSize.width / imageSize.height
        
        returnSize.height = returnSize.width / aspectRatio
        
        if returnSize.height > size.height {
            returnSize.height = size.height
            returnSize.width = size.height * aspectRatio
        }
        return returnSize
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == self.show_webview {
            if let nextVC = segue.destination as? BlogViewController {
                nextVC.blog_data = (sender as? BlogData)!
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: reuseHeaderIdentifier,
                                                                             for: indexPath) as! BlogHeaderCollectionReusableView
            headerView.HeaderTitle.text = "Branch"
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}
