//
//  BlogListViewController.swift
//  BranchBlogBasic
//
//  Created by Joseph Geraghty on 10/24/17.
//  Copyright © 2017 Branch. All rights reserved.
//

import UIKit
import Branch

private let reuseIdentifier = "Cell"

class BlogListViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    fileprivate let reuseIdentifier = "BlogDataCell"
    fileprivate let reuseHeaderIdentifier = "HeaderView"
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 5.0, right: 0.0)
    fileprivate let itemsPerRow: CGFloat = 2
    let show_webview = "showWebView"
    let pop_webview = "popBlogView"
    var blogs = [BlogData]()
    var categories = [Category]()
    var selected:Int?
    
    var page = 1
    
    @IBOutlet weak var categoryPickerTextField: UITextField!
    @IBOutlet var blogCollectionView: UICollectionView!
    var categoryPicker: UIPickerView!
    
    var categoryPickerData = ["All"]
//    var largePhotoIndexPath: IndexPath? {
//        didSet {
//            var indexPaths = [IndexPath]()
//            if let largePhotoIndexPath = largePhotoIndexPath {
//                indexPaths.append(largePhotoIndexPath as IndexPath)
//            }
//            if let oldValue = oldValue {
//                indexPaths.append(oldValue as IndexPath)
//            }
//            blogCollectionView?.performBatchUpdates({
//                self.blogCollectionView?.reloadItems(at: indexPaths)
//            }) { completed in
//                if let largePhotoIndexPath = self.largePhotoIndexPath {
//                    self.blogCollectionView?.scrollToItem(
//                        at: largePhotoIndexPath as IndexPath,
//                        at: .centeredVertically,
//                        animated: true)
//                }
//            }
//        }
//    }
    
    override func viewDidLoad() {
        if blogs.isEmpty{
           loadMoreBlogPosts(url: setGetBlogUrl(category: selected))
        }
        
        let categoryUrl: URL = URL(string: "https://blog.branch.io/wp-json/wp/v2/categories?hide_empty=1&per_page=20")!
        NetworkUtils.makeNetworkRequests(url:categoryUrl, closure:handleCategories )
        
        let layout = blogCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        if( traitCollection.forceTouchCapability == .available){
            
            registerForPreviewing(with: self, sourceView: view)
            
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            print("trigger next page load")
            page+=1
            loadMoreBlogPosts(url: setGetBlogUrl(category: selected))
        }
    }
    //handling data from categories api
    func handleCategories(_ jsonvalue: Any,_ error: Error?) {
        if error == nil {
            categories = NetworkUtils.handleCategoryData(jsonvalue)
            
            for category in categories{
                if let name = category.name{
                    categoryPickerData.append(name)
                }
            }
            DispatchQueue.main.async {
                
                
                // Adding Button ToolBar
                let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(BlogListViewController.doneClick))
                let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(BlogListViewController.cancelClick))
                
                self.categoryPickerTextField.loadDropdownData(data: self.categoryPickerData, barButtons: [cancelButton, spaceButton, doneButton], onSelect: self.pickerSelectionResponse)
            }
            //todo:: need to put these ina a dropdown and make selectable
        } else {
            print(jsonvalue)
        }
    }
    
    func pickerSelectionResponse(selectedText: String, row: Int){
        print(selectedText)
        selected = row
    }
    
    func setGetBlogUrl(category: Int?) -> String{
        var url = "https://blog.branch.io/wp-json/wp/v2/posts?_embed&page=\(page)"
        if let cat = category{
            if cat > 1{
                url += "&categories=\(categories[cat-1].id!)"
            }
        }
        return url
    }
    
    //loading more blog posts and appending them to the end of the collection view
    func loadMoreBlogPosts(url: String) {
        let url: URL = URL(string: url)!
        print(url)
        //making blog post call
        NetworkUtils.makeNetworkRequests(url:url, closure:getBlogPosts )
    }
    
    //handling the blogs posts fro mthe api
    func getBlogPosts(_ jsonvalue: Any,_ error: Error?) {
        if error == nil {
            blogs.append(contentsOf: NetworkUtils.handleBlogData(jsonvalue))
            DispatchQueue.main.async {
               self.blogCollectionView?.reloadData()
            }
        } else {
            print(jsonvalue)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func handleSwipe(gestureRecognizer: UIGestureRecognizer) {
        Branch.getInstance().userCompletedAction("Blog_open")
        self.performSegue(withIdentifier: self.show_webview, sender:(gestureRecognizer.view as! BlogCollectionViewCell).blog_data)
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
                print("I'm inside here$%$%$%")
                nextVC.blog_data = (sender as? BlogData)!
            }
        }
        
        if segue.identifier == self.pop_webview {
            if let nextVC = segue.destination as? BlogViewController {
                nextVC.blog_data = (sender as? BlogCollectionViewCell)!.blog_data
            }
        }
    }
    
    func doneClick() {
        categoryPickerTextField.resignFirstResponder()
        blogs.removeAll()
        page = 1
        self.blogCollectionView?.reloadData()
        self.categoryPickerTextField.text = categoryPickerData[selected!]
        loadMoreBlogPosts(url: setGetBlogUrl(category: selected))
    }
    
    func cancelClick() {
        categoryPickerTextField.resignFirstResponder()
        selected = nil
        //should probably set this to last selected Item rather than all
        categoryPickerTextField.text = categoryPickerData[0]
    }
}

extension BlogListViewController:  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView,
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            let availableWidth = view.frame.width
            let availableHeight = view.frame.height / 2
            return CGSize(width: availableWidth, height: availableHeight)
        }
//        if indexPath == largePhotoIndexPath as IndexPath? {
//            let photo = blogs[(indexPath as NSIndexPath).row].photo
//            var size = collectionView.bounds.size
//            size.height -= topLayoutGuide.length
//            size.height -= (sectionInsets.top + sectionInsets.right)
//            size.width -= (sectionInsets.left + sectionInsets.right)
//            return self.sizeToFillWidthOfSize(photo!,size)
//        }
        let paddingSpace = 2.5 * (itemsPerRow)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.bottom
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
//        largePhotoIndexPath = largePhotoIndexPath == indexPath ? nil : indexPath
        return false
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! BlogCollectionViewCell
        
        //Set a shadow
        let shadowPath = UIBezierPath(rect: cell.imageView.bounds).cgPath
        cell.imageView.layer.shadowColor = UIColor(white: 0.7, alpha: 0.2).cgColor
        cell.imageView.layer.shadowOffset = CGSize(width:3,height:3)
        cell.imageView.layer.shadowOpacity = 0.4
        cell.imageView.layer.masksToBounds = false
        cell.imageView.layer.shadowPath = shadowPath
        cell.imageView.layer.shadowRadius = 2
        cell.isUserInteractionEnabled = true
        
//        var view = UIView(frame: cell.frame)
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.gray.cgColor
//
//        cell.backgroundView = view
        if let photo = blogs[(indexPath as NSIndexPath).row].photo {
            cell.imageView.image = photo
        } else{
            var urlString = blogs[(indexPath as NSIndexPath).row].photourl!
            if urlString.isEmpty {
                urlString = "https://branch.io/img/logo_white.png"
            }
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print("Failed fetching image:", error)
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        print("Not a proper HTTPURLResponse or statusCode")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.blogs[(indexPath as NSIndexPath).row].addImage(image: UIImage(data: data!)!)
                        cell.imageView.image = self.blogs[(indexPath as NSIndexPath).row].photo
                    }
                    }.resume()
            }
        }
        cell.BlogTitle.text = blogs[(indexPath as NSIndexPath).row].title
        cell.blog_data = blogs[(indexPath as NSIndexPath).row]
        return cell
        
//        guard indexPath == largePhotoIndexPath else {
//            if let photo = blogs[(indexPath as NSIndexPath).row].photo {
//                cell.imageView.image = photo
//            } else{
//                var urlString = blogs[(indexPath as NSIndexPath).row].photourl!
//                if urlString.isEmpty {
//                    urlString = "https://branch.io/img/logo_white.png"
//                }
//                if let url = URL(string: urlString) {
//                    URLSession.shared.dataTask(with: url) { (data, response, error) in
//                        if error != nil {
//                            print("Failed fetching image:", error)
//                            return
//                        }
//
//                        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                            print("Not a proper HTTPURLResponse or statusCode")
//                            return
//                        }
//
//                        DispatchQueue.main.async {
//                            self.blogs[(indexPath as NSIndexPath).row].addImage(image: UIImage(data: data!)!)
//                            cell.imageView.image = self.blogs[(indexPath as NSIndexPath).row].photo
//                        }
//                        }.resume()
//                }
//            }
//            cell.BlogTitle.text = blogs[(indexPath as NSIndexPath).row].title
//            return cell
//        }
//
//        if indexPath == largePhotoIndexPath {
//            cell.isSelected = !cell.isSelected
//        }
//
////        cell.backgroundColor = UIColor.black
//
//        cell.imageView.image = blogs[(indexPath as NSIndexPath).row].photo
//        cell.blog_data = blogs[(indexPath as NSIndexPath).row]
//        cell.BlogTitle.text = blogs[(indexPath as NSIndexPath).row].title
//
//        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
//        gestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
//        gestureRecognizer.delegate = self as UIGestureRecognizerDelegate
//        cell.addGestureRecognizer(gestureRecognizer)
//
//        return cell
    }
    
    
}

extension BlogListViewController: UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = blogCollectionView?.indexPathForItem(at: location) else { return nil }
        
        guard let cell = blogCollectionView?.cellForItem(at: indexPath) else { return nil }
        
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "blog_view_controller") as? BlogViewController else { return nil }
        
        let blog = blogs[indexPath.row]
        detailVC.blog_data = blog
        
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
        
        previewingContext.sourceRect = cell.frame
        
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
//        present(viewControllerToCommit, animated: true, completion: nil)
    }
    

}
