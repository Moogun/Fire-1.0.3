//
//  ProfileCell.swift
//  Fire
//
//  Created by Moogun Jung on 10/9/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

class ProfileCell: BaseCell {
    
    var profileItem: String? {
        didSet {
            titleLabel.text = profileItem
            
        }
    }
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.sizeToFit()
        label.text = "Private Data"
        return label
    }()
    
    let textField : UITextField = {
        let tf =  UITextField()
        tf.placeholder = "Enter some data"
        tf.font = UIFont.systemFont(ofSize: 13)
        return tf
    }()
    
    let seperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 1)
        return seperatorView
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 70, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(textField)
        textField.anchor(top: nil, left: titleLabel.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, left: textField.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.frame.width, height: 0.5)
        
    }
}
