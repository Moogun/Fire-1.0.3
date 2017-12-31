//
//  QnaCategoryCell.swift
//  Fire
//
//  Created by Moogun Jung on 9/2/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

class QnaCategoryCell: BaseCell {
    
    var chapter: ChapterModel? {
        didSet {
            titleLabel.text = chapter?.title

            if let count = chapter?.questions.count {
                questionCountLabel.text = "\(count)" + " " + "Q"
            }
        }
    }
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.sizeToFit()
        label.font = FontAttributes.previewSubMenuTitleFont14Thin
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontAttributes.previewSubMenuTitleFont14Thin
        label.text = "title.numberOfLines"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let questionCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "25 Q"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let seperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 1)
        return seperatorView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(numberLabel)
        numberLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: numberLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        addSubview(questionCountLabel)
        questionCountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20 - 10).isActive = true
        questionCountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        addSubview(seperatorView)
        seperatorView.anchor(top: self.titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
}
