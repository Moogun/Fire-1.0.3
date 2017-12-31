//
//  InstructorGalleryCell.swift
//  Fire
//
//  Created by Moogun Jung on 9/8/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

class InstructorProfileCell: BaseCell {
    
    var course: CourseModel? {
        didSet {         
        }
    }
    
    var instructor: InstructorModel? {
        didSet {
            titleLabel.text = instructor?.experience
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.text = "• 해커스 토익 900"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
