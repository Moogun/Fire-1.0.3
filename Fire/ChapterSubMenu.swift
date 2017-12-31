//
//  ChapterSubMenu.swift
//  Fire
//
//  Created by Moogun Jung on 4/5/17.
//  Copyright © 2017 Moogun. All rights reserved.
////

import UIKit
import Firebase

class ChapterSubMenu: UIView {

    var chapter: Chapter_Model? {
        didSet {
            print("\(chapter?.id) new sub")
            print(chapter?.title)
        }
    }
    
//    var subChapters = [SubChapter_Model]()
    
    
    lazy var collectionView: UICollectionView = {
        let menuLayout = UICollectionViewFlowLayout()
        menuLayout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: menuLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .blue
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    
    //var horizontalBarLeftConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ChapterSubMenuCell.self, forCellWithReuseIdentifier: cellId)
        
        self.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0).isActive = true
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: true, scrollPosition: .left)
      
        setupHorizontalBar()
        fetchSubChapter()
        
    }
    
    func setupHorizontalBar() {
        
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(horizontalBarView)
        horizontalBarLeftConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/6).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.item)
        let x = CGFloat(indexPath.item) * frame.width / 6
        self.horizontalBarLeftConstraint?.constant = x
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut, animations: { 
            self.layoutIfNeeded()
        }, completion: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fetchSubChapter() {
        
        guard let chapterId = self.chapter?.id else { return }
        
        let ref = FIRDatabase.database().reference()
        ref.child("chapters/\(chapterId)/subChapterList").observe(.childAdded, with: { (snapshot) in
            
            let keywordKey = snapshot.key
            print(keywordKey)
            
            ref.child("subChapters/\(keywordKey)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let subChapter = SubChapter_Model()
                    subChapter.setValuesForKeys(dictionary)
                    self.subChapters.append(subChapter)
                    
                    DispatchQueue.main.async(execute: {
                        self.collectionView.reloadData()
                        print(self.subChapters)
                    })
                }
            })
        })
    }

    
}

extension ChapterSubMenu: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if let count = self.subChapters {
//            return count
//        }
//        return 0
        
//        return self.subChapters.count
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChapterSubMenuCell
//        cell.chapterSubMenuLabel.text = self.subChapters[indexPath.item].title
        cell.backgroundColor = .white
        return cell
    }
    
}


extension ChapterSubMenu: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 6, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


class ChapterSubMenuCell: BaseCell {

    let chapterSubMenuLabel: UILabel = {
        let indexLabel = UILabel()
        indexLabel.text = "여행"
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.textColor = .lightGray
        indexLabel.font = UIFont.boldSystemFont(ofSize: 12)
        indexLabel.sizeToFit()
        return indexLabel
    }()
    
    override var isSelected: Bool {
        didSet {
            chapterSubMenuLabel.textColor = isSelected ? .black : .lightGray
        }
    }

    override func setupViews() {
        
        self.addSubview(self.chapterSubMenuLabel)
        chapterSubMenuLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        chapterSubMenuLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
    }
    
}
