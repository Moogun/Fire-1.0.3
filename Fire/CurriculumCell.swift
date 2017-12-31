//
//  PreviewCell.swift
//  Fire
//
//  Created by Moogun Jung on 3/4/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

//chapter
class CurriculumCell: BaseCell {
    
    var chapter: ChapterModel? {
        didSet {
            
            if let title = chapter?.title {
                self.titleLabel.text = "\(title)"
            }
            
            if let details = chapter?.chapterDescription {
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
//                paragraphStyle.firstLineHeadIndent = 15
//                paragraphStyle.headIndent = 15
                
                let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular), NSAttributedStringKey.paragraphStyle : paragraphStyle,NSAttributedStringKey.foregroundColor: UIColor.darkGray]
                self.detailTextView.attributedText = NSAttributedString(string: details, attributes: attributes)
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
        //label.textColor = .black
        label.textColor = .darkGray
        label.font = FontAttributes.previewSubMenuTitleFont14Thin
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.sizeToFit()
        label.textColor = .black
//        label.textColor = .darkGray
        label.isUserInteractionEnabled = false
        label.font = FontAttributes.previewSubMenuTitleFont14Thin
        return label
    }()
    
    let detailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textAlignment = .left
        textView.textContainer.lineFragmentPadding = 0
        textView.isUserInteractionEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        //textView.textColor = .darkGray
        return textView
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func setupViews() {
        
        self.addSubview(self.numberLabel)
        numberLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        

        self.addSubview(self.titleLabel)
        titleLabel.anchor(top: numberLabel.topAnchor, left: numberLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        self.addSubview(self.detailTextView)
        detailTextView.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 4, paddingRight: 20, width: 0, height: 0)


        addSubview(seperatorView)
        seperatorView.anchor(top: self.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        
    }

}
