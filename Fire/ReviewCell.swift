//
//  ReviewCell.swift
//  Fire
//
//  Created by Moogun Jung on 8/12/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCell: BaseCell {
    
    let ratingView: CosmosView = {
        let cosmos = CosmosView()
        cosmos.rating = 0
        cosmos.settings.starSize = 13
        cosmos.settings.starMargin = 0
        cosmos.settings.fillMode = .half
        cosmos.settings.filledImage = #imageLiteral(resourceName: "star")
        cosmos.settings.emptyImage = #imageLiteral(resourceName: "starBlank")
        return cosmos
    }()
    
    let detailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isEditable = false
        //textView.textAlignment = .justified
        textView.text = "This course is great. The instructor is always clear and accountable. I had stuck at one point, and it was really depression, but I solved the issue with the help of the instructor"
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Moogun"
        return label
    }()
    
    let seperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor.rgb(red: 228, green: 228, blue: 228)
        return seperatorView
    }()

    override func setupViews() {
        super.setupViews()
        
        self.addSubview(self.ratingView)
        ratingView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        self.addSubview(self.detailTextView)
        detailTextView.anchor(top: ratingView.bottomAnchor, left: ratingView.leftAnchor, bottom: nil, right: ratingView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        self.addSubview(titleLabel)
        titleLabel.anchor(top: detailTextView.bottomAnchor, left: ratingView.leftAnchor, bottom: nil, right: ratingView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 0, height: 20)
        
        self.addSubview(seperatorView)
        seperatorView.anchor(top: titleLabel.bottomAnchor, left: detailTextView.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
}
