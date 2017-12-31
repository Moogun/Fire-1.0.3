//
//  AccountHeader.swift
//  Fire
//
//  Created by Moogun Jung on 9/8/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

//MARK:- Protocol

protocol AccountHeaderDelegate {
    func handleProfile()
}

//MARK:- header

class AccountHeader: BaseCell  {
    
    var delegate: AccountHeaderDelegate?
    
    var user: UserModel? {
        didSet {
            
            if let profileImageUrl = user?.profileImageUrl, !profileImageUrl.isEmpty {
                self.profileImageView.loadImage(urlString: profileImageUrl)
            }
            
            usernameLabel.text = user?.name
            emailLabel.text = user?.email
        }
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "chapter")
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email@gmail.com"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        return label
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(self.tintColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        //        button.layer.borderColor = UIColor.lightGray.cgColor
        //        button.layer.borderWidth = 0.5
        //        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit Profile", for: .normal)
        //button.setImage(#imageLiteral(resourceName: "Settings").withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    let seperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 1)
        return seperatorView
    }()
    
    //MARK:- Action - Editing
    
    @objc func editProfile() {
        self.delegate?.handleProfile()
    }
    
    //MARK:- layout
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 40, height: 40) //was 60 
        profileImageView.clipsToBounds = true
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: profileImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
//        addSubview(emailLabel)
//        emailLabel.anchor(top: usernameLabel.bottomAnchor, left: usernameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        editProfileButton.centerYAnchor.constraint(equalTo: self.usernameLabel.centerYAnchor).isActive = true
        
        addSubview(seperatorView)
        seperatorView.anchor(top: self.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: -1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 0.5)
                
    }
    
}

