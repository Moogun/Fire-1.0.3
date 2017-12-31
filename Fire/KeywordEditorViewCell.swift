//
//  KeywordEditViewCell.swift
//  Fire
//
//  Created by Moogun Jung on 4/10/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit

class KeywordEditorViewCell: KeywordBaseCell {

    var keyword: Keyword_Model? {
        didSet {
            
            self.keywordLayout()
            
        }
    }
    
    //duplicaate must refactor
    func keywordLayout() {
        
        if let title = self.keyword?.keyword, let pronun = self.keyword?.pronunciation {
            
            let titleColor = UIColor(r: 31, g:75, b:165, a: 1)
            let  pronunciationColor = UIColor(r: 155, g:155, b:155, a: 1)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.defaultTabInterval = 5
            
            let attributedText = NSMutableAttributedString(string: title, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 24, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: titleColor])
            
            attributedText.append(NSAttributedString(string: "\t\(pronun)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular), NSForegroundColorAttributeName: pronunciationColor]))
            //was 16
            attributedText.addAttributes([NSParagraphStyleAttributeName : paragraphStyle], range: NSMakeRange(0, attributedText.length))
            
            self.titleLabel.attributedText = attributedText
            
        }
        
        guard let meaning_1 = self.keyword?.meaning_1, let eg_1 = self.keyword?.eg_1, let egMeaning_1 = self.keyword?.egMeaning_1 else { return }
        
        let paragraphStyle_cn = NSMutableParagraphStyle()
        paragraphStyle_cn.lineSpacing = 4
        let pronunciationColor = UIColor(r: 155, g:155, b:155, a: 1)
        
        let paragraphStyle_en = NSMutableParagraphStyle()
        paragraphStyle_en.lineSpacing = 1
        
        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.lineSpacing = 4
        paragraphStyle2.lineHeightMultiple = 0.1
        
        let paragraphHeight = NSMutableAttributedString(string: "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)])
        
        paragraphHeight.addAttributes([NSParagraphStyleAttributeName: paragraphStyle2], range: NSMakeRange(0, paragraphHeight.length))
        
        
        let attributedText_1 = NSMutableAttributedString(string: "\(meaning_1) \n\(eg_1): \(egMeaning_1)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)]) // was 15
        
        if let lang = self.keyword?.language, lang == "cn" {
            
            attributedText_1.addAttributes([NSParagraphStyleAttributeName: paragraphStyle_cn], range: NSMakeRange(0, attributedText_1.length))
            self.textView_1.attributedText = attributedText_1
            
        } else {
            
            attributedText_1.addAttributes([NSParagraphStyleAttributeName: paragraphStyle_en], range: NSMakeRange(0, attributedText_1.length))
            self.textView_1.attributedText = attributedText_1
            
        }
        
        
        if let egPronun_1 = self.keyword?.egPronun_1 {
            
            attributedText_1.append(NSAttributedString(string: "\n\(egPronun_1)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular), NSForegroundColorAttributeName: pronunciationColor]))
            attributedText_1.append(paragraphHeight)
            
            self.textView_1.attributedText = attributedText_1
            
        }
        
        
        if let meaning_2 = self.keyword?.meaning_2, let eg_2 = self.keyword?.eg_2, let egMeaning_2 = self.keyword?.egMeaning_2 {
            
            let attributedText_2 = NSMutableAttributedString(string: "\n\(meaning_2) \n\(eg_2) : \(egMeaning_2)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)])
            
            
            if let lang = self.keyword?.language, lang == "cn" {
                
                attributedText_2.addAttributes([NSParagraphStyleAttributeName: paragraphStyle_cn], range: NSMakeRange(0, attributedText_2.length))
                self.textView_1.attributedText = attributedText_1
                
            } else {
                
                attributedText_2.addAttributes([NSParagraphStyleAttributeName: paragraphStyle_en], range: NSMakeRange(0, attributedText_2.length))
                self.textView_1.attributedText = attributedText_1
                
            }
            
            attributedText_1.append(attributedText_2)
            
            self.textView_1.attributedText = attributedText_1
            
        }
        
        if let egPronun_2 = self.keyword?.egPronun_2 {
            
            attributedText_1.append(NSAttributedString(string: "\n\(egPronun_2)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular), NSForegroundColorAttributeName: pronunciationColor]))
            
            self.textView_1.attributedText = attributedText_1
            
        }
    }
    
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 3
        //        title.sizeToFit()
        return title
    }()
    
    let keywordImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: textView
    
    let textView_1: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
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
    
    let seperatorView: UIView = {
        let seperatorView = UIView()
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 1)
        return seperatorView
    }()
    
    
    fileprivate struct Margins {
        static let widthMargin = CGFloat(-54)
    }

    
    override func setupViews() {
        super.setupViews()


        self.addSubview(self.titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: Margins.widthMargin).isActive = true

        
        self.addSubview(self.keywordImageView)
        keywordImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        keywordImageView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0).isActive = true
        keywordImageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: Margins.widthMargin).isActive = true
        keywordImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        
        self.addSubview(self.textView_1)
        textView_1.topAnchor.constraint(equalTo: keywordImageView.bottomAnchor, constant: 0).isActive = true
        textView_1.leftAnchor.constraint(equalTo: keywordImageView.leftAnchor, constant: 0).isActive = true
        textView_1.widthAnchor.constraint(equalTo: self.widthAnchor, constant: Margins.widthMargin).isActive = true

                
    }
    
}


//        self.addSubview(seperatorView)
//        seperatorView.topAnchor.constraint(equalTo: textView_1.bottomAnchor, constant: 10).isActive = true
//        seperatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
//        seperatorView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
//        seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true


//        self.addSubview(self.textField)
//        textField.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: 10).isActive = true
//        textField.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0).isActive = true
//        textField.widthAnchor.constraint(equalTo: self.widthAnchor, constant: Margins.widthMargin).isActive = true
//        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true

