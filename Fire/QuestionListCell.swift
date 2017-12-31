//
//  QnaCell.swift
//  Fire
//
//  Created by Moogun Jung on 8/5/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

protocol QuestionListCellDelegate {
    func likeQuestion(for cell: QuestionListCell)
    func followQuestion(for cell: QuestionListCell)
}

class QuestionListCell: BaseCell {
    
    var delegate: QuestionListController?
    
    var question: QuestionModel? {
        didSet {
            
            // Top section
            if let profileImageUrl = question?.user?.profileImageUrl, !profileImageUrl.isEmpty {
                profileImageView.loadImage(urlString: profileImageUrl)
            }
            usernameLabel.text = question?.user?.name
            createdAtLabel.text = question?.createdAt.timeAgoDisplay()
            
            
            // Question Text and Image

            if let questionText = question?.text {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4

                let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular), NSAttributedStringKey.paragraphStyle : paragraphStyle]
                let attributedText = NSAttributedString(string: questionText, attributes: attributes)
                
                questionTextView.attributedText = attributedText
            }
            
            
            //BOTTOM
            
            //----------- ANSWER COUNT
            if let answerCount = question?.answers.count {
                    let attributedText = NSMutableAttributedString(string: "\(answerCount)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : UIColor.darkGray])
                    commentLabel.attributedText = attributedText
            }
            
            //----------- LIKE & FOLLOW --------------
            
            likeButton.setImage(question?.hasLiked == true ? #imageLiteral(resourceName: "like20_red").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like20").withRenderingMode(.alwaysOriginal), for: .normal)
            
             followButton.setImage(question?.hasFollowed == true ? #imageLiteral(resourceName: "follow20_red").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "follow20").withRenderingMode(.alwaysOriginal), for: .normal)
           
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

    //MARK:- Middle Section Objects
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "질문 제목"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 16) //15
//        //label.textColor = .darkGray
//        label.sizeToFit()
//        return label
//    }()
    
    let indexLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = FontAttributes.titleWordColor
        label.sizeToFit()
        return label
    }()
    
    let indexBoxImageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "box")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.isEditable = false
        textView.text = "이건 뭔가요?"
        textView.isUserInteractionEnabled = false
        textView.textContainer.maximumNumberOfLines = 2
        return textView
    }()
    var questionImageViewHeightAnchor: NSLayoutConstraint?
    
    
     //MARK:- BOTTOM SECTION OBJECTS

    let commentImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "comm16")
        return imageView
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.sizeToFit()
        return label
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "rate").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc func likeButtonDidTap() {
        delegate?.likeQuestion(for: self)
    }
    
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "rate").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(followButtonDidTap), for: .touchUpInside)
        return button
    }()

    @objc func followButtonDidTap() {
        delegate?.followQuestion(for: self)
    }
    
    let seperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 1)
        return seperatorView
    }()
    
    
    
    //MARK:- Layout
    
    override func setupViews() {
        super.setupViews()
        
        //MARK: top section
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 40, height: 40) // padding top was 20
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(createdAtLabel) // worked in 8 plus
        createdAtLabel.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 10).isActive = true
        createdAtLabel.bottomAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        
        //BADGE ----------------------------------------------------------------------
//        self.addSubview(indexBoxImageView)
//        indexBoxImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
//        indexBoxImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
//        indexBoxImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            //self.indexBoxImageView.addSubview(self.indexLabel)
        
//        addSubview(indexLabel)
//        indexLabel.anchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
//        //indexLabel.centerXAnchor.constraint(equalTo: indexBoxImageView.centerXAnchor, constant: 0).isActive = true
//        indexLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor, constant: 0).isActive = true
        
        
        //MARK: MIDDLE SECTION

        addSubview(questionTextView)
        questionTextView.anchor(top: profileImageView.centerYAnchor, left: usernameLabel.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 26, paddingRight: 20, width: 0, height: 0)
 
        addSubview(likeButton)
        likeButton.anchor(top: questionTextView.bottomAnchor, left: questionTextView.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 50, height: 20)
        
        addSubview(followButton)
        followButton.anchor(top: questionTextView.bottomAnchor, left: likeButton.rightAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 50, height: 20)
        
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.frame.width, height: 0.5)
    }
    
}
