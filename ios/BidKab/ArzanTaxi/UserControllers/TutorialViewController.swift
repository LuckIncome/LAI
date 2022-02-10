//
//  TutorialViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/14/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class TutorialViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TutorialViewControllerDelegate {
    
    let cellID = "tutCellID"
    
    let coverView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.alpha = 0
        
        return view
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        layout.scrollDirection = .horizontal
        
        return cv
    }()
    
    let pageControl : UIPageControl = {
        let pc = UIPageControl()
        
        pc.pageIndicatorTintColor = UIColor.rgb(red: 47, green: 128, blue: 237, alpha: 0.5)
        pc.currentPageIndicatorTintColor = .blue
        pc.numberOfPages = 3
        
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(TutorialCell.self, forCellWithReuseIdentifier: cellID)
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-5)
            make.height.equalTo(30)
        }
    }
    
    func handleContinue() {
        if pageControl.currentPage == 2 {
            view.addSubview(coverView)
            coverView.frame = view.frame
            
            UIView.animate(withDuration: 0.5, animations: {
                self.coverView.alpha = 1
            })
            
            let navController = UINavigationController(rootViewController: LoginViewController())
            
            present(navController, animated: true, completion: nil)
            return
        }
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! TutorialCell
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}
