//
//  LibraryCell.swift
//  Fire
//
//  Created by Moogun Jung on 3/4/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit 

class CourseCell: BaseCell {

    var courseInfo: InfoModel? {
        didSet {
            
            self.titleLabel.text = courseInfo?.title
            self.instructorLabel.text = courseInfo?.instructor
            
            self.courseImageView.image = #imageLiteral(resourceName: "chapter")
            
            if let courseImageUrl = courseInfo?.courseImageUrl, !courseImageUrl.isEmpty {
                courseImageView.loadImage(urlString: courseImageUrl)
            }
            
        }
    }
    
    
    let courseImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    let instructorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.sizeToFit()
        return label
    }()
    
    override func setupViews() {
        
        backgroundColor = .white
        addSubview(courseImageView)
        addSubview(titleLabel)
        addSubview(instructorLabel)
        
        courseImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        courseImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, instructorLabel])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: self.courseImageView.bottomAnchor, constant: 10),
                                     stackView.leftAnchor.constraint(equalTo: self.courseImageView.leftAnchor, constant: 0),
                                     stackView.rightAnchor.constraint(equalTo: self.courseImageView.rightAnchor, constant: 0)])
    }
    
}


