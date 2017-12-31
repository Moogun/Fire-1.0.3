//
//  HomeCell.swift
//  Fire
//
//  Created by Moogun Jung on 7/17/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

class HomeCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CoursePreviewHeaderDelegate {
    
    var course: Course_Model? {
        didSet {
            print(course?.title)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(collectionView)
        
        collectionView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        self.collectionView.alwaysBounceVertical = true
        //self.collectionView.isScrollEnabled = true
        
        collectionView.register(CoursePreviewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(CoursePreviewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    //MARK: - 111
    var headerHeight: CGFloat = 275 + 30
    
    func resizeHeaderHeight(desc: String) {
        collectionView.collectionViewLayout.invalidateLayout()
        
        self.headerHeight += estimatedHeightForText(desc) - 50 - 30 - 6
        
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
    
    private func estimatedHeightForText(_ text: String) -> CGFloat {
        let approximateWidthOfDescription = self.frame.width - 40
        let size = CGSize(width: approximateWidthOfDescription, height: 1000)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]

        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        print(estimatedFrame.height)
        return estimatedFrame.height
    }

    
}

// MARK:- Datasource

extension HomeCell {

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CoursePreviewHeader
        header.backgroundColor = UIColor.cyan
        header.course = course
        header.courseRemoved = { [weak self] in
//            self?.navigationController?.popViewController(animated: true)
        }

        header.delegate = self
        return header
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let chaptersCount = course?.chapters.count {
            return chaptersCount
        }
        return 0

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CoursePreviewCell
        let chapter = course?.chapters[indexPath.item]
        cell.chapter = chapter
        return cell

    }

}

// MARK:- Delegate

extension HomeCell {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.width, height: headerHeight) //200 + 100
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 56)
    }
}

