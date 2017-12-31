//
//  InstructorCourseCell.swift
//  Fire
//
//  Created by Moogun Jung on 9/8/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Cosmos

class InstructorCourseCell: BaseCell {
    
    var course: CourseModel? {
        didSet {
            self.courseImageView.image = #imageLiteral(resourceName: "chapter")
            
            if let courseImageUrl = course?.info?.courseImageUrl, !courseImageUrl.isEmpty {
                courseImageView.loadImage(urlString: courseImageUrl)
            }
            self.titleLabel.text = course?.info?.title
            self.instructorLabel.text = course?.info?.instructor
            
            if let attendee = course?.attendee?.count, attendee > 0 {
                self.attendeeLabel.text = "\(attendee)"
            } else {
                self.attendeeLabel.text = "0"
            }
                        
        }
    }
    
    let courseImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.text = "• 해커스 토익 900"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "토익 900점 필수 어휘 1000개"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instructorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "David Cho"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    let reviewersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.light)
        label.text = "1234 reviews"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let attendeeView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = #imageLiteral(resourceName: "students")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let attendeeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.thin)
        label.text = "236"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        
        contentView.addSubview(courseImageView)
        courseImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        courseImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel, instructorLabel])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: self.courseImageView.topAnchor, constant: 0),
                                     stackView.leftAnchor.constraint(equalTo: self.courseImageView.rightAnchor, constant: 10),
                                     stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -90),
                                     stackView.heightAnchor.constraint(equalTo: courseImageView.heightAnchor)])
        
//        contentView.addSubview(starRatingView)
//        starRatingView.anchor(top: stackView.topAnchor, left: stackView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
//
//        contentView.addSubview(reviewersLabel)
//        reviewersLabel.anchor(top: starRatingView.bottomAnchor, left: starRatingView.leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        contentView.addSubview(attendeeView)
        attendeeView.anchor(top: instructorLabel.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 50, width: 0, height: 0)
        
        contentView.addSubview(attendeeLabel)
        attendeeLabel.anchor(top: attendeeView.topAnchor, left: attendeeView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
//        contentView.addSubview(attendeeView)
//        attendeeView.anchor(top: reviewersLabel.bottomAnchor, left: starRatingView.leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
//
//        contentView.addSubview(attendeeLabel)
//        attendeeLabel.anchor(top: reviewersLabel.bottomAnchor, left: attendeeView.rightAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 4, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        let seperatorView = UIView()
        self.addSubview(seperatorView)
        
        seperatorView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        seperatorView.anchor(top: nil, left: stackView.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
}

