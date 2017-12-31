//
//  InstructorHeader.swift
//  Fire
//
//  Created by Moogun Jung on 9/10/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

protocol InstructorHeaderDelegate {
    func didChangeToCourse()
    func didChangeToProfile()
}

class InstructorHeader: BaseCell {
    
    var delegate: InstructorController?
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.contentHorizontalAlignment = .center
        button.tintColor = self.tintColor
        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc func backButtonDidTap() {
        self.delegate?.dismiss(animated: true, completion: nil)
    }
    
    let bgView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.image = #imageLiteral(resourceName: "bg")
        return imageView
    }()
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "voong")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 45
        return imageView
    }()
    
    let instructorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.text = "조진휘"
        label.sizeToFit()
        return label
    }()
    
    lazy var profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이력", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.contentHorizontalAlignment = .center
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(profileButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    lazy var courseButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .center
        button.setTitle("수업", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.tintColor = self.tintColor
        button.addTarget(self, action: #selector(courseButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc func profileButtonDidTap() {
        profileButton.tintColor = self.tintColor
        courseButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
        delegate?.didChangeToProfile()
    }
    
    @objc func courseButtonDidTap() {
        profileButton.tintColor = UIColor.init(white: 0, alpha: 0.2)
        courseButton.tintColor = self.tintColor
        delegate?.didChangeToCourse()
    }
    
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        
        addSubview(bgView)
        bgView.anchor(top: window?.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.frame.width, height: 170)
        
        addSubview(backButton)
        backButton.anchor(top: bgView.topAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 90, height: 90)
        profileImageView.centerYAnchor.constraint(equalTo: bgView.bottomAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        addSubview(instructorLabel)
        instructorLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        instructorLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15).isActive = true
        
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        let stackView = UIStackView(arrangedSubviews: [courseButton, profileButton])
        stackView.backgroundColor = .red
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        
        addSubview(stackView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 50)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
}

