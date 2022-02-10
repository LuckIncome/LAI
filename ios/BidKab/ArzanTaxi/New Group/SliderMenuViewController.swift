//
//  SliderMenuViewController.swift
//  BidKab
//
//  Created by Eldor Makkambayev on 8/29/19.
//  Copyright © 2019 Nursultan Zhiyembay. All rights reserved.
//

import UIKit

class SliderMenuViewController: UIViewController, SWRevealViewControllerDelegate {

    var sliders: [UIImage] = [#imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "5")]
    
    lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SliderCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: SliderCollectionViewCell.self))
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var skipButton: UIButton = {
        let sb = UIButton()
        sb.setTitleColor(UIColor(red: 30/255, green: 50/255, blue: 136/255, alpha: 0.5), for: .normal)
        sb.backgroundColor = .white
        sb.setTitle(.localizedString(key: "skip"), for: .normal)
        sb.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        sb.addTarget(self, action: #selector(goToStart), for: .touchUpInside)
        return sb
    }()
    
    lazy var nextButton: UIButton = {
        let sb = UIButton()
        sb.setTitleColor(.white, for: .normal)
        sb.backgroundColor = .blue
        sb.layer.cornerRadius = 15
        sb.setTitle(.localizedString(key: "start"), for: .normal)
//        sb.isHidden = true
        sb.addTarget(self, action: #selector(goToStart), for: .touchUpInside)
        return sb
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
//        pageControl.backgroundColor = .red
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .blue
        pageControl.numberOfPages = self.sliders.count
//        pageControl.addTarget(self, action: #selector(), for: .touchUpInside)
        return pageControl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupViews()
    }
    
    private func setupBackground() -> Void {
        view.backgroundColor = .white
    }
    
    @objc func goToStart() -> Void {
        let rootViewController = UINavigationController(rootViewController: ConfidentialViewController())

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.rootViewController = rootViewController
        }
    }
    
//    @objc func goToSelectedPage(sender: UIPageControl) -> Void {
//        pageControl.currentPage = sender.
//    }
    
    private func setupViews() -> Void {
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-60)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            } else {
                make.top.equalToSuperview().offset(60)
            }
            make.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(-10)
        }
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            } else {
                make.top.equalToSuperview().offset(20)
            }
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(pageControl.snp.top).offset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
    }
}

extension SliderMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SliderCollectionViewCell.self), for:  indexPath) as! SliderCollectionViewCell
        cell.imageView.image = sliders[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let indexPath = collectionView.indexPathsForVisibleItems.first else {return}
        pageControl.currentPage = indexPath.item
    }
}

