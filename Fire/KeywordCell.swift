//
//  KeywordSimpleViewCell.swift
//  Fire
//
//  Created by Moogun Jung on 4/8/17.
//  Copyright © 2017 Moogun. All rights reserved.
//

import UIKit
protocol KeywordCellDelegate {
    func checkedKeyword(for cell: KeywordCell)
}
class KeywordCell: BaseCell, UIGestureRecognizerDelegate {
    
    var keyword: KeywordModel? {
        didSet {
            titleLabel.text = self.keyword?.keyword
            
            guard let hasChecked = keyword?.hasChecked else { return }
            guard let keyword = keyword?.keyword else { return }
            
            if hasChecked {
                self.checkBoxButton.setImage(#imageLiteral(resourceName: "Checkbox"), for: .normal)
                let highlight = [NSAttributedStringKey.backgroundColor: UIColor.yellow]
                let attributedText = NSMutableAttributedString(string: keyword, attributes: highlight)
                self.titleLabel.attributedText = attributedText
                // strikethrough attributes: [NSAttributedStringKey.strikethroughStyle : 1]) // 0 means none
             
            } else {
                self.checkBoxButton.setImage(#imageLiteral(resourceName: "blankCheckbox"), for: .normal)
                let noHhighlight = [NSAttributedStringKey.backgroundColor: UIColor.white]
                let attributedText = NSMutableAttributedString(string: keyword, attributes: noHhighlight)
                self.titleLabel.attributedText = attributedText
            }
            
            
            if self.keyword?.eg_1 != nil {
                moreButton.isHidden = false
            } else {
                moreButton.isHidden = true
            }
            
        }
    }
    
    var delegate: KeywordController?
    
    @objc func keywordDidTap() {
        delegate?.checkedKeyword(for: self)
    }
    
    override var isSelected: Bool {
        didSet {

            let sub = NSMutableAttributedString(string: "", attributes:[NSAttributedStringKey.paragraphStyle : NSTextAlignment.left])
            let empty = NSMutableAttributedString(string: "")

            if let pronunciation = self.keyword?.pronunciation {
                let pronun = NSMutableAttributedString(string: "  |" + pronunciation + "| " , attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.thin), NSAttributedStringKey.foregroundColor: UIColor.darkGray])
               sub.append(pronun)
            }

            if let meaning_1 = self.keyword?.meaning_1 {
               let meaning = NSMutableAttributedString(string: " " + meaning_1, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.thin), NSAttributedStringKey.foregroundColor: UIColor.black])
               sub.append(meaning)
            }

            self.meaningLabel.attributedText = isSelected ? sub : empty
            
        }
    }
    
    let blackView = UIView()
    let detailView = UIView()
    
    @objc func handleDismiss() {
        blackView.removeFromSuperview()
        detailView.removeFromSuperview()
    }
    
    let indexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.thin)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
//    let openTitleTap = UITapGestureRecognizer(target: self, action: #selector(openDetails))
//
//    @objc func openDetails() {
//        print("openDetails")
//    }
    
    let meaningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()

    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular), NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        let attributedText = NSMutableAttributedString(string: Text.more, attributes: attributes)
        button.setAttributedTitle(attributedText, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        
        button.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc func moreButtonDidTap() {
        
        guard let window = UIApplication.shared.keyWindow else { return }
//
//        if isSelected == true {
//            keyword?.hasChecked = true
//
            window.addSubview(blackView)
            window.addSubview(detailView)
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.frame = window.frame
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            detailView.backgroundColor = .white
            detailView.layer.cornerRadius = 6
        
            detailView.anchor(top: window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingBottom: 150, paddingRight: 60, width: 0, height: 0)
            
            guard let keyword = self.keyword?.keyword, let meaning = self.keyword?.meaning_1 else { return }
        
            let titleLabelDetail: UILabel = {
                let label = UILabel()
                
                let attributedText = NSMutableAttributedString(string: "")
                
                let titleMeaningFont = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]
                let pronunFont = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular), NSAttributedStringKey.foregroundColor : UIColor.darkGray]
                
                
                if let pronunciation = self.keyword?.pronunciation {
                    
                    attributedText.append(NSMutableAttributedString(string: keyword, attributes: titleMeaningFont))
                    attributedText.append(NSMutableAttributedString(string: " |" + pronunciation + "| ", attributes: pronunFont))
                    attributedText.append(NSMutableAttributedString(string: meaning, attributes: titleMeaningFont))
                } else {
                    attributedText.append(NSMutableAttributedString(string: keyword + " : " + meaning, attributes: titleMeaningFont))
                }
                
                
                label.attributedText = attributedText
                label.translatesAutoresizingMaskIntoConstraints = false
//                label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.thin)
                   //label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
                label.lineBreakMode = .byTruncatingTail
                label.numberOfLines = 2
                label.sizeToFit()
                return label
            }()
            
            let detailTextView: UITextView = {
                let textView = UITextView()
                // Nov 22 not working for dynamic textview height textView.translatesAutoresizingMaskIntoConstraints = false
                textView.sizeToFit()
                textView.isScrollEnabled = false
                textView.isEditable = false
                textView.font = UIFont.systemFont(ofSize: 16)
                //textView.textAlignment = .justified
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                paragraphStyle.headIndent = 11
                
                let egAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular), NSAttributedStringKey.paragraphStyle : paragraphStyle]
                let pronunAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular), NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.paragraphStyle : paragraphStyle]
                let hiddenAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular), NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle : paragraphStyle]
                
                
                // tip: bullet point \u{2022} , \n new line
                
                let details = NSMutableAttributedString(string: "")
                //let whiteBulletPoint = NSMutableAttributedString(string: "\n\u{2022} ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
                
                if let eg_1 = self.keyword?.eg_1 {
                    details.append(NSMutableAttributedString(string: "\u{25B8} " + eg_1, attributes: pronunAttributes))
                    textView.attributedText = details
                }
                
                
                if let egPronun_1 = self.keyword?.egPronun_1 {
                    details.append(NSMutableAttributedString(string: " [" + egPronun_1 + "]", attributes: pronunAttributes))
                    textView.attributedText = details
                }
                
                if let egMeaning_1 = self.keyword?.egMeaning_1 {
                    // 3 spaces in the string
                    //details.append(whiteBulletPoint)
                    details.append(NSMutableAttributedString(string: "\n\u{25B8} ", attributes: hiddenAttributes)) // 2 blank spaces
                    details.append(NSMutableAttributedString(string: egMeaning_1, attributes: egAttributes)) // 2 blank spaces
                    textView.attributedText = details
                }
                
                if let eg_2 = self.keyword?.eg_2 {
                    details.append(NSMutableAttributedString(string: "\n\n\u{25B8} " + eg_2, attributes: pronunAttributes))
                    //details.append(NSMutableAttributedString(string: eg_2, attributes: egAttributes))
                    textView.attributedText = details
                }
                
                if let egPronun_2 = self.keyword?.egPronun_2 {
                    details.append(NSMutableAttributedString(string: " [" + egPronun_2 + "]", attributes: pronunAttributes))
                    textView.attributedText = details
                }
                
                if let egMeaning_2 = self.keyword?.egMeaning_2 {
                    //details.append(whiteBulletPoint) two blank spaces
           
                    details.append(NSMutableAttributedString(string: "\n\u{25B8} ", attributes: hiddenAttributes)) // 2 blank spaces
                    details.append(NSMutableAttributedString(string: egMeaning_2, attributes: egAttributes)) // 2 blank spaces
                    textView.attributedText = details
                    
                    textView.attributedText = details
                }
               
                let plainString = details.string
                //let textRange = NSMakeRange(0, details.length)

                plainString.enumerateSubstrings(in: plainString.startIndex..<plainString.endIndex, options: .byWords) {
                    (substring, substringRange, _, _) in
                    if substring == keyword {
                        details.addAttribute(.foregroundColor, value: Text.mainColor,
                                                      range: NSRange(substringRange, in: plainString))
                        textView.attributedText = details
                    }
                }
                //textView.backgroundColor = .blue
                textView.textContainer.lineFragmentPadding = 0
                return textView
            }()
            
            detailView.addSubview(titleLabelDetail)
            detailView.addSubview(detailTextView)
        
            titleLabelDetail.anchor(top: detailView.topAnchor, left: detailView.leftAnchor, bottom: nil, right: detailView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
            detailTextView.anchor(top: titleLabelDetail.bottomAnchor, left: titleLabelDetail.leftAnchor, bottom: detailView.bottomAnchor, right: titleLabelDetail.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 0, height: 0)
        
    }
    
    let checkBoxImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "blankCheckbox")
        return imageView
    }()
    
    lazy var checkBoxButton: UIButton = {
        let bt = UIButton(type: .custom)
        bt.setImage(#imageLiteral(resourceName: "blankCheckbox"), for: .normal)
        bt.addTarget(self, action: #selector(keywordDidTap), for: .touchUpInside)
        return bt
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.addSubview(indexBoxImageView)
        indexBoxImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        indexBoxImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        indexBoxImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.indexBoxImageView.addSubview(self.indexLabel)
        indexLabel.centerXAnchor.constraint(equalTo: indexBoxImageView.centerXAnchor, constant: 0).isActive = true
        indexLabel.centerYAnchor.constraint(equalTo: indexBoxImageView.centerYAnchor, constant: 0).isActive = true
        
        self.addSubview(self.titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: indexBoxImageView.centerYAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.indexBoxImageView.rightAnchor, constant: 10).isActive = true
        
        self.addSubview(self.meaningLabel)
        meaningLabel.centerYAnchor.constraint(equalTo: indexBoxImageView.centerYAnchor).isActive = true
        meaningLabel.leftAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 10).isActive = true
        
        //Note Nove 16 right anchor make the label right aligned for some reason oddly
        let width = self.frame.width - 40 - 10 - titleLabel.frame.width - 10 - 86
        meaningLabel.anchor(top: nil, left:  self.titleLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: width, height: 0)
        
//        self.addSubview(checkBoxImage)
//        checkBoxImage.anchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 60, width: 16, height: 16)
//        checkBoxImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.addSubview(checkBoxButton)
        checkBoxButton.anchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 60, width: 32, height: 32)
        checkBoxButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(self.moreButton)
        moreButton.centerYAnchor.constraint(equalTo: indexBoxImageView.centerYAnchor).isActive = true
        moreButton.anchor(top: nil, left: nil, bottom: nil, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 40, height: 40) //self.frame.height
        //moreButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10)
        
        
    }
    
}
