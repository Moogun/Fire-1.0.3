//
//  AccountCell.swift
//  Fire
//
//  Created by Moogun Jung on 7/30/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
import Firebase

class AccountCell: BaseCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    override func setupViews() {
        self.backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
