//
//  FeaturedCell.swift
//  Fire
//
//  Created by Moogun Jung on 8/5/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Cosmos


class FeaturedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var category: Category_Model? {
        didSet {
            if let title = category?.title {
                categoryTitleLabel.text = title
            }
        }
    }
    
    let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 2
        label.text = "New Course"
        label.textColor = .darkGray
        label.sizeToFit()
        return label
    }()
    
    let cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let appCellId = "cellId"
    
    override func setupViews() {
        super.setupViews()
        
        
        cv.dataSource = self
        cv.delegate = self
        
        cv.register(AppCell.self, forCellWithReuseIdentifier: appCellId)
        
        self.addSubview(categoryTitleLabel)
        self.addSubview(cv)
        
        categoryTitleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        cv.anchor(top: categoryTitleLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: -10, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = category?.courses?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appCellId, for: indexPath) as! AppCell
    
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.rgb(red: 228, green: 228, blue: 228).cgColor
        
        cell.course = category?.courses?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: self.frame.height - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}

class AppCell: BaseCell {
    
    var course: CourseModel? {
        didSet {
            
//            titleLabel.text = course?.title
        }
    }
    
    let courseImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = #imageLiteral(resourceName: "voong")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 2
        label.text = "Learn and Angular JS"
        label.sizeToFit()
        return label
    }()
    
    let instructorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.text = "by CodeABC team"
        label.sizeToFit()
        return label
    }()
    
    
    let starRatingView: CosmosView = {
        let cosmos = CosmosView()
        cosmos.rating = 3.5
        cosmos.settings.starSize = 13
        cosmos.settings.starMargin = 0
        cosmos.settings.fillMode = .half
        cosmos.settings.filledImage = #imageLiteral(resourceName: "star")
        cosmos.settings.emptyImage = #imageLiteral(resourceName: "starBlank")
        return cosmos
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(courseImageView)
        
        courseImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 90)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, instructorLabel, starRatingView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: self.courseImageView.bottomAnchor, constant: 6),
                                     stackView.leftAnchor.constraint(equalTo: self.courseImageView.leftAnchor, constant: 0),
                                     stackView.rightAnchor.constraint(equalTo: self.courseImageView.rightAnchor, constant: 0)])
        
    }
}


//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowOpacity = 1
//        cell.layer.shadowOffset = CGSize.zero
//        cell.layer.shadowRadius = 20
