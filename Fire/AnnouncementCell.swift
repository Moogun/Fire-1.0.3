//
//  AnnounCell.swift
//  Fire
//
//  Created by Moogun Jung on 8/12/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
protocol AnnouncementCellDelegate  {
    func deleteAnnouncementButtonDidTap(for cell: AnnouncementCell)
}

class AnnouncementCell: BaseCell {
    
    var announcement: AnnouncementModel? {
        didSet {
            
            if let profileImageUrl = announcement?.user.profileImageUrl, !profileImageUrl.isEmpty {
                print(profileImageUrl)
                profileImageView.loadImage(urlString: profileImageUrl)
            }
            
            if let name = announcement?.user.name {
                usernameLabel.text = name
            }
            
            if let createdAt = announcement?.createdAt {
                createdAtLabel.text = createdAt.timeAgoDisplay()
            }            
            
            if let imageUrl = announcement?.imageUrl, !imageUrl.isEmpty {
                imageView.loadImage(urlString: imageUrl)
                imageViewHeightAnchor?.constant = 300
            } else {
                imageViewHeightAnchor?.constant = 0
            }

            if let title = announcement?.title {
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                
                let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular), NSAttributedStringKey.paragraphStyle : paragraphStyle]
                self.titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
                
            }
//            else {
//                // no announcement
//            }

        }
    }
    
//    var noItem: (()->Void)?
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "chapter")
        
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    //username + date created
 
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "User name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        return label
    }()
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
        label.text = "3days ago"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.sizeToFit()
        return label
    }()
   
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "질문 제목"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14) //15
        label.numberOfLines = 0
        //label.textColor = .darkGray
        label.sizeToFit()
        return label
    }()
    
    let imageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "placeholderView60")
        return imageView
    }()
    
    let textView : UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textContainer.lineFragmentPadding = 0
        textView.isEditable = false
        return textView
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular), NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        let attributedText = NSMutableAttributedString(string: Text.delete, attributes: attributes)
        button.addTarget(self, action: #selector(deleteAnswerButtonDidTap), for: .touchUpInside)
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    var delegate: PreviewController?
    
    @objc func deleteAnswerButtonDidTap() {
        
        delegate?.deleteAnnouncementButtonDidTap(for: self)
    }
    
    let seperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 1)
        return seperatorView
    }()
    
    var imageViewHeightAnchor: NSLayoutConstraint?
    
    override func setupViews() {
        super.setupViews()
    
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40) // padding top was 20
    
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
        addSubview(createdAtLabel)
        createdAtLabel.anchor(top: nil, left: usernameLabel.rightAnchor, bottom: usernameLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: usernameLabel.bottomAnchor, left: usernameLabel.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 2 + 4, paddingLeft: 0, paddingBottom: 10 - 6, paddingRight: 20, width: 0, height: 0)
    
//        addSubview(imageView)
//        imageView.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
//        imageViewHeightAnchor = imageView.heightAnchor.constraint(equalToConstant: 0)
//        imageViewHeightAnchor?.isActive = true
//
//        addSubview(textView)
//        textView.anchor(top: imageView.bottomAnchor, left: imageView.leftAnchor, bottom: self.bottomAnchor, right: imageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(moreButton)
        moreButton.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 50, height: 20)

        addSubview(seperatorView)
        seperatorView.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.frame.width, height: 0.5)
    }
}

