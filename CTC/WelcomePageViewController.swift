//
//  WelcomePageViewController.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-04-15.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
    
    
    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var images : [String] = ["","first", "second", "third", "fourth","fifth","sixth","seventh","eighth"]
    var descriptionLabelText = ["","Welcome To the 201 Day principal of achievement - 1", "Welcome To the 201 Day principal of achievement - 2","Welcome To the 201 Day principal of achievement - 3","Welcome To the 201 Day principal of achievement - 4","Welcome To the 201 Day principal of achievement - 5","Welcome To the 201 Day principal of achievement - 6","Welcome To the 201 Day principal of achievement - 7","Welcome To the 201 Day principal of achievement - 8"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0 )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        
        onboardingCollectionView.showsVerticalScrollIndicator = false
        onboardingCollectionView.showsHorizontalScrollIndicator = false
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath)
        if(indexPath.row == images.startIndex){
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath)
            return cell
        
        }
        else{
    
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "middleCell", for: indexPath) as! OnboardingMiddleCell
            
            cell.imageView.image = UIImage(named: images[indexPath.row])
            cell.descriptionLabel.text = descriptionLabelText[indexPath.row]
            
    return cell
        
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        
        let pageNo = x / view.frame.width
        
        pageControl.currentPage = Int(pageNo)
    }
    
 
}
