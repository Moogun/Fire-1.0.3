//
//  AboutCell.swift
//  Fire
//
//  Created by Moogun Jung on 8/7/17.
//  Copyright © 2017 Moogun. All rights reserved.

import UIKit

class AboutCell: BaseCell {

    var about: AboutModel? {
        didSet {
            
//            if let aboutImageUrl = about?.aboutImageUrl, !aboutImageUrl.isEmpty {
//                imageView.loadImage(urlString: aboutImageUrl)
//                imageViewHeightAnchor?.constant = 200
//            } else {
//                imageViewHeightAnchor?.constant = 0
//            }
//
            if let title = about?.title {
                self.titleLabel.text = "\(title)"
            }
            
            if let details = about?.details {
                print(details)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular), NSAttributedStringKey.paragraphStyle : paragraphStyle]
                self.detailTextView.attributedText = NSAttributedString(string: details, attributes: attributes)
            }
    
        }
    }
    
    let imageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "chapter")
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.sizeToFit()
        label.textColor = .darkGray
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)
        return label
    }()
    
    let detailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textAlignment = .left
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = .yellow
        return textView
    }()
    
    let seperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor.init(white: 0, alpha: 0.2) //UIColor.rgb(red: 112, green: 112, blue: 112)
        return seperatorView
    }()
    
    
    var imageViewHeightAnchor: NSLayoutConstraint?
    
    override func setupViews() {
        super.setupViews()
        
//        self.addSubview(self.imageView)
//        imageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//        imageViewHeightAnchor = imageView.heightAnchor.constraint(equalToConstant: 140)
//        imageViewHeightAnchor?.isActive = true
//
        self.addSubview(self.titleLabel)
        titleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 8, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        self.addSubview(self.detailTextView)
        detailTextView.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 4, paddingRight: 20, width: 0, height: 0)
        
    }
    
}
