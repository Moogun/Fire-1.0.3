//
//  CoursePreviewController.swift
//  Fire
//
//  Created by Moogun Jung on 12/29/16.
//  Copyright © 2016 Moogun. All rights reserved.
//

import UIKit
import Firebase

class CoursePreviewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
   
    var course: Course_Model? {
        didSet {
            navigationItem.title = course?.title
        }
    }
    
    let cellId = "cellId"
    
    let homeCellId = "homeCellId"
    let faqCellId = "faqCellId"
    let chatCellId = "chatCellId"
  
    lazy var menuBar: MenuBar = {
        let menuBar = MenuBar()
        menuBar.coursePreviewController = self
        return menuBar
    }()
    
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true

        setupCollectionView()
        setupMenuBar()
        
        automaticallyAdjustsScrollViewInsets = false
        
    }
    
    func setupCollectionView() {
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.isPagingEnabled = true
        
        collectionView?.backgroundColor = .white
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: homeCellId)
    
        collectionView?.contentInset = UIEdgeInsetsMake(200, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(30, 0, 0, 0)

    }
    
    func setupMenuBar() {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        view.addSubview(whiteView)
        whiteView.anchor(top: self.view.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        self.view.addSubview(menuBar)
        menuBar.anchor(top: self.topLayoutGuide.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
    }
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
        
    }

    
        //    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        //        collectionView?.collectionViewLayout.invalidateLayout()
        //        DispatchQueue.main.async(execute: {
        //            self.collectionView?.reloadData()
        //        })
        //    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellId, for: indexPath) as! HomeCell
        cell.course = self.course
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 30 - 100)
    }
    
}
