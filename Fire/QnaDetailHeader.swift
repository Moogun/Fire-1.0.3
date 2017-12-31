//
//  QnaDetailHeader.swift
//  Fire
//
//  Created by Moogun Jung on 9/5/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

protocol QnaDetailHeaderDelegate {
    func followQuestion()
    func likeQuestion()
}

class QnaDetailHeader: BaseCell {
    
    var question: QuestionModel? {
        didSet {
    
            if let profileImageUrl = question?.user?.profileImageUrl, !profileImageUrl.isEmpty {
                profileImageView.loadImage(urlString: profileImageUrl)
            }
            usernameLabel.text = question?.user?.name
            createdAtLabel.text = question?.createdAt.timeAgoDisplay()
            
            //----------- LIKE -- FOLLOW --------------------------------------------
            //image size 40 
            likeButton.setImage(question?.hasLiked == true ? #imageLiteral(resourceName: "like40_red").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like40").withRenderingMode(.alwaysOriginal), for: .normal)
            
            likeLabel.text = "\(question?.likeCount ?? 0) " + Text.likeCount
            followButton.setImage(question?.hasFollowed == true ? #imageLiteral(resourceName: "follow40_red").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "follow40").withRenderingMode(.alwaysOriginal), for: .normal)
            
            //----------- QUESTION  --------------------------------------------
            if let questionText = question?.text {
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                
                let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular), NSAttributedStringKey.paragraphStyle : paragraphStyle]
                let attributedText = NSAttributedString(string: questionText, attributes: attributes)
                questionTextView.attributedText = attributedText
                
            }
            
            //----------- IMAGE  --------------------------------------------
            
            if let questionImageUrl = question?.questionImageUrl, !questionImageUrl.isEmpty {
                questionImageView.loadImage(urlString: questionImageUrl)
                questionImageViewHeightAnchor?.constant = 300
            } else {
                questionImageViewHeightAnchor?.constant = 0
            }

        }
    }
    
    //MARK:- Top Section Objects
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "chapter")
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
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
    
    //MARK:- Middle Section Objects
    
    let questionImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "chapter")
        
        return imageView
    }()
    
    let questionTextView : UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15)
        // below two needed to remove padding
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        //
        textView.isEditable = false
        textView.text = "이건 뭔가요?"
        return textView
    }()
    
    var delegate: QnaDetailController?
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like20"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc func likeButtonDidTap() {
        delegate?.likeQuestion()
    }
    
    let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "10명이 좋아합니다."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.sizeToFit()
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Favourite-1"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(followButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc func followButtonDidTap() {
        delegate?.followQuestion()
    }
    

    
    let seperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 1)
        return seperatorView
    }()
    
    var questionImageViewHeightAnchor: NSLayoutConstraint?
    
    //MARK:- Layout
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 40, height: 40) // padding top was 20
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(createdAtLabel)
        createdAtLabel.anchor(top: profileImageView.centerYAnchor, left: usernameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
//        addSubview(followQuestionButton)
//        followQuestionButton.anchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
//        followQuestionButton.centerYAnchor.constraint(equalTo: self.userImageView.centerYAnchor).isActive = true

//        addSubview(titleLabel)
//        titleLabel.anchor(top: userImageView.bottomAnchor, left: userImageView.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        addSubview(questionImageView)
        questionImageView.anchor(top: profileImageView.bottomAnchor, left: profileImageView.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        questionImageViewHeightAnchor = questionImageView.heightAnchor.constraint(equalToConstant: 0)
        questionImageViewHeightAnchor?.isActive = true
        
        addSubview(questionTextView)
        //questionTextView.backgroundColor = .yellow
        questionTextView.anchor(top: questionImageView.bottomAnchor, left: questionImageView.leftAnchor, bottom: nil, right: questionImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(likeButton)
        //likeButton.backgroundColor = .yellow
        likeButton.anchor(top: questionTextView.bottomAnchor, left: questionTextView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        addSubview(followButton)
        //bookmarkButton.backgroundColor = .yellow
        followButton.anchor(top: likeButton.topAnchor, left: likeButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        addSubview(likeLabel)
        likeLabel.anchor(top: likeButton.bottomAnchor, left: likeButton.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
        
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.frame.width, height: 1)
    }
    
 
}

