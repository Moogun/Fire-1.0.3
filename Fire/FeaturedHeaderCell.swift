//
//  FeaturedHeaderCell.swift
//  Fire
//
//  Created by Moogun Jung on 8/5/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

class FeaturedHeaderCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var category: Category_Model? {
        didSet {
            print(category?.courses?.count as Any)
        }
    }

    let cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false 
        return cv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor.rgb(red: 247, green: 154, blue: 27)
        pc.numberOfPages = 4
        return pc
    }()
    
    let bannerCellId = "bannerCellId"
    
    override func setupViews() {
        super.setupViews()
        
        
        cv.dataSource = self
        cv.delegate = self
        
        addSubview(cv)
        addSubview(pageControl)
        cv.register(BannerCell.self, forCellWithReuseIdentifier: bannerCellId)
        cv.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 0, height: 0)
        pageControl.anchor(top: cv.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        pageControl.centerXAnchor.constraint(equalTo: cv.centerXAnchor).isActive = true
        
        
        guard let count = self.category?.courses?.count else { return }
        pageControl.numberOfPages = count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = self.category?.courses?.count {
            print("banners courses:", count)
            return count
        }

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerCellId, for: indexPath) as! BannerCell
        cell.course = category?.courses?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK:- page Control
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = targetContentOffset.pointee.x / contentView.frame.width
        pageControl.currentPage = Int(pageNumber)
    }
    
}

class BannerCell: BaseCell {
    
    var course: CourseModel? {
        didSet {
            
//            if let courseImageUrl = course?.courseImageUrl, !courseImageUrl.isEmpty {
//                courseImageView.loadImage(urlString: courseImageUrl)
//            }
        }
    }

    let courseImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = #imageLiteral(resourceName: "kHistory")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        addSubview(courseImageView)
        courseImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 90)
    }
}
