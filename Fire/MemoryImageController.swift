//
//  MemoryImageController.swift
//  Fire
//
//  Created by Moogun Jung on 12/24/16.
//  Copyright © 2016 Moogun. All rights reserved.
//

import UIKit

class MemoryImageController: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let memoryId = "memoryId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
       
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .gray
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MemoryImageCell.self, forCellWithReuseIdentifier: memoryId)
        
        addSubview(collectionView)
//        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
//        collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -24).isActive = true
//        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -24).isActive = true
        
// work        collectionView.frame = CGRect(x: 0, y: 0, width: 300, height: 150)
/////  not work              collectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memoryId, for: indexPath) as! MemoryImageCell
        cell.backgroundColor = .yellow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: 100, height: 50)
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class MemoryImageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        print("Let's see")
        print(frame.width)
        print(frame.height)
        backgroundColor = .white
    }
    
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
