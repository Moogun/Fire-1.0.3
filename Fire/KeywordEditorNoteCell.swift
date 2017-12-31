//
//  KeywordEditorNoteCell.swift
//  Fire
//
//  Created by Moogun Jung on 4/12/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

class KeywordEditorNoteCell: KeywordBaseCell {
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        //imageView.image =
        return imageView
    }()
    
    let noteLabel: UILabel = {
        let note = UILabel()
        note.translatesAutoresizingMaskIntoConstraints = false
        note.lineBreakMode = .byWordWrapping
        note.numberOfLines = 3
        note.text = "This shows users comments"
        note.font = UIFont.systemFont(ofSize: 12)
        
        note.sizeToFit()
        return note
    }()
    
    let seperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 1)
        return seperatorView
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = "Enter Answer Here!"
        return textField
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.addSubview(profileImageView)
        self.profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.addSubview(noteLabel)
        self.noteLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 10).isActive = true
        self.noteLabel.topAnchor.constraint(equalTo: self.profileImageView.topAnchor, constant: 0).isActive = true
        self.noteLabel.widthAnchor.constraint(equalTo: self.widthAnchor ,constant: -105).isActive = true
//        self.noteLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        self.addSubview(seperatorView)
        seperatorView.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 10).isActive = true
        seperatorView.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 10).isActive = true
        seperatorView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true


    }
    
}


//        self.addSubview(self.textField)
//        textField.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: 10).isActive = true
//        textField.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0).isActive = true
//        textField.widthAnchor.constraint(equalTo: self.widthAnchor, constant: Margins.widthMargin).isActive = true
//        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
