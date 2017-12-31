//
//  QnaDetailCell.swift
//  Fire
//
//  Created by Moogun Jung on 9/5/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

protocol QnaDetailCellDelegate {
    func deleteAnswerButtonDidTap(for cell: QnaDetailCell)
}

class QnaDetailCell: BaseCell {
    
    var answer: AnswerModel? {
        didSet {
            
            if let profileImageUrl = answer?.user?.profileImageUrl, !profileImageUrl.isEmpty {
                profileImageView.loadImage(urlString: profileImageUrl)
            }
            usernameLabel.text = answer?.user?.name
            createdAtLabel.text = answer?.createdAt.timeAgoDisplay()
            answerTextView.text = answer?.text
           
            //1
            setupAnswerDeleteButton()
        }
    }
    
    func setupAnswerDeleteButton() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //not my answer // seems working without else clause 
        if uid != answer?.uid {
            moreButton.removeFromSuperview()
            answerTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true // set it to -
        }
    }
    
    var delegate: QnaDetailController?
    
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
    
    let answerTextView : UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.text = "이건 뭔가요?"
        // below two needed to remove padding
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        //
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular), NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        let attributedText = NSMutableAttributedString(string: Text.like, attributes: attributes)
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular), NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        let attributedText = NSMutableAttributedString(string: Text.delete, attributes: attributes)
        button.addTarget(self, action: #selector(deleteAnswerButtonDidTap), for: .touchUpInside)
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    @objc func deleteAnswerButtonDidTap() {
        delegate?.deleteAnswerButtonDidTap(for: self)
    }
    
    let seperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 1)
        return seperatorView
    }()
    
    let seperatorVerticalView: UIView = {
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 1)
        return seperatorView
    }()
    
    //MARK:- Layout
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 40, height: 40) // padding top was 20
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        addSubview(createdAtLabel)
        createdAtLabel.anchor(top: usernameLabel.topAnchor, left: usernameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)


        //adjusted padding on Nov 6 for misplacement
        addSubview(answerTextView)
        //answerTextView.backgroundColor = .yellow
        answerTextView.anchor(top: profileImageView.centerYAnchor, left: usernameLabel.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 20, width: 0, height: 0)
        
        /**
         Nove 13: Save below for later use when adding like to answers
         
        addSubview(likeButton)
        likeButton.backgroundColor = .yellow
        likeButton.anchor(top: answerTextView.bottomAnchor, left: answerTextView.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 50, height: 20)

        addSubview(moreButton)
        moreButton.anchor(top: likeButton.topAnchor, left: likeButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 50, height: 20)
         
        */
        addSubview(moreButton)
        moreButton.anchor(top: answerTextView.bottomAnchor, left: answerTextView.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 50, height: 20)

        
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, left: self.usernameLabel.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.frame.width, height: 0.5)
        
    }
}
